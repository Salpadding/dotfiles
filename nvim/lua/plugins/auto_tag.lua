local main = "nvim-ts-autotag"
return {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    main = main,
    config = function()
        local autotag = require(main)
        autotag.setup {}
    end
}
