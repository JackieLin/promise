###
 * promise 信息
 * @author jackie Lin <dashi_lin@163.com>
 * @date 2016-3-9
###
'use strict'

((window) ->
    ###
     * promise list
    ###
    promises = []

    Promise = (cb=->)->
        @.init()
        @._cb = cb

        ###
         * 0 - pending
         * 1 - fulfilled with _value
         * 2 - rejected with _value
         * 3 - adopted the state of another promise, _value
        ###
        @._status = 0
        @._value = null
        # then list
        @._deferred = []
        # 是否异步加载（false: 同步）
        @._async = false

        # 入栈操作
        promises.push @

        @._cb.apply null, [@.resolve.bind(@), @.reject.bind(@)]


    ###
     * 绑定方法到对应的上下文
    ###
    bind = (context=@)->
        throw new TypeError '绑定对象应该是一个方法' if @ isnt 'function'
        aArgs = Array.prototype.slice.call arguments, 1
        fToBind = @

        warpperFunc = ->
            fToBind.apply context, aArgs.concat Array.prototype.slice.call arguments

        warpperFunc


    ###
     * 初始化操作
    ###
    Promise::init = ->
        @._status = 0
        @._value = null
        Function.prototype.bind = bind if not Function.prototype.bind


    ###
     * 执行  then 队列
    ###
    Promise::resolve = (res)->
        @._status = 1
        @._value = res
        @.run()
        # 异步，跳转到上一个 promise
        @.next()

        @

    Promise::reject = (res)->
        @._status = 2
        @._value = res
        @


    ###
     * 抛异常处理
    ###
    Promise::fail = (cb)->
        return false if @._status isnt 2
        @._value = cb.apply @, [@._value]

        @


    ###
     * 下一步控制
    ###
    Promise::next = ->
        # 没有 done 结束，同步到上一层
        @.notify() if not @._done and promises.length and not @._deferred.length

    ###
     * 执行 then 方法
    ###
    Promise::run = ->
        @.doThen()

        if @._done
            @.doDone @._done


    ###
     * then 方法
    ###
    Promise::then = (cb)->
        if @._status in [0, 3]
            @._async = true
            @._deferred.push cb

        # resolve 已经触发, 直接执行 then 方法
        if @._status is 1
            @._async = false
            @.handleThen cb

        @


    ###
     * 执行 then
    ###
    Promise::doThen = ->
        if not @._deferred.length
            return

        if @._deferred.length and @._status is 1
            @handleThen @._deferred.shift(), =>
                @.doThen()

    ###
     * 执行回调方法
    ###
    Promise::handleThen = (func, callback=->)->
            _value = func.apply @, [@._value]
            # promise 异步加载
            if _value instanceof Promise and _value._async
                @._status = 3
            # promise 同步加载
            else if _value instanceof Promise and not _value._async
                @._value = _value._value
                # 弹出最后一个
                promises.pop()
                callback.apply @
            else
                @._value = _value
                callback.apply @


    ###
     * 将对应的值同步到上一个空间
    ###
    Promise::notify = ->
        prev = getPrevPromise()

        if prev
            prev._value = @._value

            # 删除掉最后一个
            promises.pop()

            prev._status = 1
            prev.run()


    ###
     * 获取上一个 promise 列表
    ###
    getPrevPromise = ->
        length = promises.length
        prev = null
        if length > 1
            prev = promises[length - 2]

        prev


    Promise::doDone = (done)->
        @._value = done.apply @, [@._value]
        @.notify()
        promises.pop()
        if promises.length
            prev = promises[promises.length - 1]
            # 重置状态
            prev._status = 1
            prev.run()

    ###
     * 结束
    ###
    Promise::done = (cb)->
        if @._status in [0, 3]
            @._done = cb

        if @._status is 1
            @.doThen()
            @.doDone cb

        @


    # amd
    return window.Promise = Promise if not window.define

    if window.define
        window.define ->
            Promise
) window
