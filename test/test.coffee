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

    it 'then test normal', (done)->
        # normal promise
        promise.then (res)->
            return 333
        .then (res) ->
            (res).should.be.exactly 333
            done()

    it 'then test promise', (done)->
        promise.then (res)->
            333
        .then (res) ->
            (res).should.be.exactly 333
            333
        .then (res)->
            new Promise (resolve, reject)->
                window.setTimeout ->
                    resolve 222
                , 500
            .then (res) ->
                (res).should.be.exactly 222
                444
            .done (res) ->
                # 必须
                res
        .then (res) ->
            (res).should.be.exactly 444
            res

        .done (res) ->
            done()

    it 'promise fail', ->
        new Promise (resolve, reject) ->
            reject 'error'
        .fail (res) ->
            (res).should.be.exactly 'error'
