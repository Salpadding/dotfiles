local main = "nvim-ts-autotag"
return {
    "windwp/nvim-ts-autotag",
    main = main,
    config = function()
        local autotag = require(main)
        autotag.setup {}
    end
}
