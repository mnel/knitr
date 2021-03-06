context('Parser')

test_that('parsing options', {
    expect_identical(parse_params('a,b=T,c=def'), list(label='a',b=TRUE,c='def'))
    expect_error(parse_params('a,b,c=qwer'))
    expect_identical(parse_params('label=xx,opt=zz'),list(label='xx',opt='zz'))
})


test_that('parsing inline texts', {
    knit_patterns$set(all_patterns$rnw)

    res =
        parse_inline(c('aaa \\SweaveOpts{eval=TRUE,dev=png,animate=T}',
                       'bbb \\SweaveOpts{eval=F,dev=tikz,abc=1,comment=} and \\Sexpr{1+2}',
                       'another expression \\Sexpr{rnorm(10)}'))

    expect_identical(res$params, list(eval=FALSE, dev='tikz', abc=1L, comment=NA))
    expect_identical(res$code, c('1+2', 'rnorm(10)'))
    expect_identical(nchar(res$input), 62L)

    res = parse_inline('\\SweaveOpts{a=1}\\SweaveOpts{b=FALSE}')
    expect_identical(res$params, list(b=FALSE))
    expect_identical(nchar(res$input), 0L)

    knit_patterns$restore()
})
