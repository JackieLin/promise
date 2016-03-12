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
        promise.then11 (res)->
            return 333
        .then11 (res) ->
            (res).should.be.exactly 333
            done()

    it 'then test promise', (done)->
        promise.then11 (res)->
            return 333
        .then11 (res) ->
            (res).should.be.exactly 333
        .then11 (res)->
            new Promise (resolve, reject)->
                window.setTimeout ->
                    resolve 222
                , 500
            .then11 (res) ->
                (res).should.be.exactly 222
                444
            .done11 (res) ->
                # 必须
                res

        .then11 (res) ->
            (res).should.be.exactly 444
            done()

