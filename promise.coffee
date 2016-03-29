###
 * promise 信息
 * @author jackie Lin <dashi_lin@163.com>
 * @date 2016-3-9
###

((window) ->
    ###
     * promise list
    ###
    promises = []

    Promise = (cb=->)->
        init()
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


    init = ->
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

        @

    Promise::reject = ->
        @._status = 2
        @._value = res
        @

    ###
     * 执行 then
    ###
    Promise::doThen = ->
        if not @._deferred.length
            return

        if @._deferred.length and @._status is 1
            _value = @._deferred.shift().apply @, [@._value]
            if _value instanceof Promise
                @._status = 3
            else
                @._value = _value
                @.doThen()


    Promise::run = ->
        @.doThen()
        if @._done
            @.doDone @._done


    getPrevPromise = ->
        length = promises.length
        prev = null
        if length > 1
            prev = promises[length - 2]

        prev

    ###
     * 将对应的值同步到上一个空间
    ###
    Promise::notify = ->
        prev = getPrevPromise()
        if prev
            prev._value = @._value


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
    Promise::donePromise = (cb)->
        if @._status in [0, 3]
            @._done = cb

        if @._status is 1
            @.doThen()
            @.doDone cb

        @


    Promise::thenPromise = (cb)->
        if @._status in [0, 1, 3]
            @._deferred.push cb

        @

    # amd
    return window.Promise = Promise if not window.define

    if window.define
        window.define ->
            Promise
) window
