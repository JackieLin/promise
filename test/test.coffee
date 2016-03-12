###
 * 测试 Promise
 * @author jackie Lin <dashi_lin@163.com>
###
promise = null
describe 'Promise', ->
    it '#new Promise', (done)->
        promise = new Promise (resolve, reject)->
            window.setTimeout ->
                resolve 111
                done()
            , 1000

    # it 'then test normal', ->
    #     # normal promise
    #     promise.then (res)->
    #         return 333
    #     .then (res) ->
    #         console.log res

    it 'then test promise', ->
        # normal promise
        promise.then (res)->
            return new Promise (resolve, reject)->
                window.setTimeout ->
                    resolve 222
                , 1000
        .then (res) ->
            console.info res

