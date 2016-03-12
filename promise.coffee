###
 * promise 信息
 * @author jackie Lin <dashi_lin@163.com>
 * @date 2016-3-9
###

((window) ->
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

        # promise 延时列表
        @._deferred = []

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


    Promise::resolve = (res)->
        @._status = 1
        @._value = res
        @

    Promise::reject = ->
        @._status = 2
        @._value = res
        @

    Promise::then = (cb) ->
        if @._status isnt 3
            _value = cb.apply null, [@._value]

        if @._status is 3
            @._deferred.push cb

        # 返回对象为 Promise
        if _value instanceof Promise
            @._status = 3
        # @._value = cb.apply null, [@._value]
        @

    # amd
    return window.Promise = Promise if not window.define

    if window.define
        window.define ->
            Promise

) window
