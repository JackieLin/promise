###
 * 测试 Promise
 * @author jackie Lin <dashi_lin@163.com>
###
promise = null
describe 'Promise', ->
    it '#new Promise', ->
        promise = new Promise (resolve, reject)->
            window.setTimeout ->
                resolve 111
            , 1000

    it 'thenPromise test normal', (donePromise)->
        # normal promise
        promise.thenPromise (res)->
            return 333
        .thenPromise (res) ->
            (res).should.be.exactly 333
            donePromise()

    it 'thenPromise test promise', (donePromise)->
        promise.thenPromise (res)->
            333
        .thenPromise (res) ->
            (res).should.be.exactly 333
            333
        .thenPromise (res)->
            new Promise (resolve, reject)->
                window.setTimeout ->
                    resolve 222
                , 500
            .thenPromise (res) ->
                (res).should.be.exactly 222
                444
            .donePromise (res) ->
                # 必须
                res
        .thenPromise (res) ->
            (res).should.be.exactly 444
            res

        .donePromise (res) ->
            donePromise()

