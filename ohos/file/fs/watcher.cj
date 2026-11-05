/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// The Cangjie API is in Beta. For details on its capabilities and limitations, please refer to the README file.

package ohos.file.fs

import ohos.business_exception.BusinessException
import ohos.ffi.{RemoteDataLite, releaseFFIData, SUCCESS_CODE}
import ohos.labels.APILevel

class WatchEventListenerImpl {
    let callback_: (WatchEvent) -> Unit
    
    init(callback: (WatchEvent) -> Unit) {
        this.callback_ = callback
    }
}

/**
 * Provides APIs for observing events.
 */
@!APILevel[
    since: "26.1.0",
    syscap: "SystemCapability.FileManagement.File.FileIO"
]
public class WatchEventListener {
    private var watchEventListenerImpl: WatchEventListenerImpl
    
    prop callback_: (WatchEvent) -> Unit {
        get() {
            return watchEventListenerImpl.callback_
        }
    }

    /**
     * Creates a **WatchEventListener** object with the specified callback function. The callback function is invoked
     * each time an observed event occurs.
     *
     * @param { (WatchEvent) -> Unit } callback - Callback function to be invoked when an observed event occurs.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.FileManagement.File.FileIO"
    ]
    public init(callback: (WatchEvent) -> Unit) {
        this.watchEventListenerImpl = WatchEventListenerImpl(callback)
    }
}

class WatchEventImpl {
    let fileName_: String
    let event_: UInt32
    let cookie_: UInt32

    init(
        fileName: String,
        event: UInt32,
        cookie: UInt32
    ) {
        this.fileName_ = fileName
        this.event_ = event
        this.cookie_ = cookie
    }
}

/**
 * Defines the event to observe.
 */
@!APILevel[
    since: "26.1.0",
    syscap: "SystemCapability.FileManagement.File.FileIO"
]
public class WatchEvent {
    private var watchEventImpl: WatchEventImpl

    /**
     * Sandbox path of the file to observe. The sandbox path contains the file name.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.FileManagement.File.FileIO"
    ]
    public prop fileName: String {
        get() {
            return watchEventImpl.fileName_
        }
    }

    /**
     * Events to observe. Multiple events can be separated by vertical bars.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.FileManagement.File.FileIO"
    ]
    public prop event: UInt32 {
        get() {
            return watchEventImpl.event_
        }
    }

    /**
     * Cookie bound with the event.
     *
     * Currently, only the **IN_MOVED_FROM** and **IN_MOVED_TO** events are supported. The **IN_MOVED_FROM** and
     * **IN_MOVED_TO** events of the same file have the same **cookie** value.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.FileManagement.File.FileIO"
    ]
    public prop cookie: UInt32 {
        get() {
            return watchEventImpl.cookie_
        }
    }

    /**
     * Creates a **WatchEvent** object.
     *
     * @param { String } fileName - Sandbox path of the file to observe. The sandbox path contains the file name.
     * @param { UInt32 } event - Events to observe. Multiple events can be separated by vertical bars.
     * @param { UInt32 } cookie - Cookie bound with the event. Currently, only the **IN_MOVED_FROM** and **IN_MOVED_TO**
     *     events are supported. The **IN_MOVED_FROM** and **IN_MOVED_TO** events of the same file have the same
     *     **cookie** value.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.FileManagement.File.FileIO"
    ]
    public init(
        fileName: String,
        event: UInt32,
        cookie: UInt32
    ) {
        this.watchEventImpl = WatchEventImpl(fileName, event, cookie)
    }
}

class WatcherImpl <: RemoteDataLite {
    init(instanceId: Int64) {
        super(instanceId)
    }

    ~init() {
        releaseFFIData(myDataId)
    }

    prop id: Int64 {
        get() {
            return getID()
        }
    }
}

/**
 * Provides APIs for observing the changes of files or directories. Before using the APIs of **Watcher**, call
 * **createWatcher()** to create a **Watcher** object.
 */
@!APILevel[
    since: "26.1.0",
    syscap: "SystemCapability.FileManagement.File.FileIO"
]
public class Watcher {
    private var watcherImpl: WatcherImpl

    init(instanceId: Int64) {
        this.watcherImpl = WatcherImpl(instanceId)
    }

    /**
     * Starts listening.
     *
     * @throws { BusinessException } 13900002 - No such file or directory
     * @throws { BusinessException } 13900005 - I/O error
     * @throws { BusinessException } 13900008 - Bad file descriptor
     * @throws { BusinessException } 13900011 - Out of memory
     * @throws { BusinessException } 13900012 - Permission denied
     * @throws { BusinessException } 13900013 - Bad address
     * @throws { BusinessException } 13900015 - File exists
     * @throws { BusinessException } 13900018 - Not a directory
     * @throws { BusinessException } 13900020 - Invalid argument
     * @throws { BusinessException } 13900021 - File table overflow
     * @throws { BusinessException } 13900022 - Too many open files
     * @throws { BusinessException } 13900025 - No space left on device
     * @throws { BusinessException } 13900030 - File name too long
     * @throws { BusinessException } 13900042 - Unknown error
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.FileManagement.File.FileIO",
        throwexception: true
    ]
    public func start(): Unit {
        unsafe {
            let errCode = FfiOHOSFileFsWatcherStart(watcherImpl.id)
            if (errCode != SUCCESS_CODE) {
                FS_LOG.error(getErrorInfo(errCode))
                throw BusinessException(errCode, getErrorInfo(errCode))
            }
        }
    }

    /**
     * Stops listening and removes the **Watcher** object.
     *
     * @throws { BusinessException } 13900002 - No such file or directory
     * @throws { BusinessException } 13900005 - I/O error
     * @throws { BusinessException } 13900008 - Bad file descriptor
     * @throws { BusinessException } 13900011 - Out of memory
     * @throws { BusinessException } 13900012 - Permission denied
     * @throws { BusinessException } 13900013 - Bad address
     * @throws { BusinessException } 13900015 - File exists
     * @throws { BusinessException } 13900018 - Not a directory
     * @throws { BusinessException } 13900020 - Invalid argument
     * @throws { BusinessException } 13900021 - File table overflow
     * @throws { BusinessException } 13900022 - Too many open files
     * @throws { BusinessException } 13900025 - No space left on device
     * @throws { BusinessException } 13900030 - File name too long
     * @throws { BusinessException } 13900042 - Unknown error
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.FileManagement.File.FileIO",
        throwexception: true
    ]
    public func stop(): Unit {
        unsafe {
            let errCode = FfiOHOSFileFsWatcherStop(watcherImpl.id)
            if (errCode != SUCCESS_CODE) {
                FS_LOG.error(getErrorInfo(errCode))
                throw BusinessException(errCode, getErrorInfo(errCode))
            }
        }
    }
}
