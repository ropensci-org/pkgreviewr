arginfo <- function(fun) {
    args <- as.list(formals(fun))
    nargs <- length(args)
    miss <- logical(nargs)
    for (i in seq_along(args)) {
        a <- args[[i]]
        miss[i] <- missing(a)
    }

    as.data.frame(cbind(arg = names(args),
                        has_default = ! miss,
                        default_value = ifelse(miss, NA, args)))
}
