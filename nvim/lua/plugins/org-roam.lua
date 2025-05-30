return
  {
    "chipsenkbeil/org-roam.nvim",
    tag = "0.1.1",
    dependencies = {
      {
        "nvim-orgmode/orgmode",
        tag = "0.3.7",
      },
    },
    config = function()
      require("org-roam").setup({
        directory = "~/org/roam",
        templates = {
          d = {
            description = "default",
            target = "TEMPLATE.org",
            template = "#+title: ${1:title}\n#+date : %U\n\n",
          },
          b = {
            description = "books",
            target = "books/TEMPLATE.org",
            template = "#+title: ${1:title}\n#+filetags: :books:\n\n",
          },
          u = {
            description = "university",
            target = "uni/TEMPLATE.org",
            template = "#+title: ${1:title}\n#+filetags: :uni:\n\n"
          },
          w = {
            description = "my writings",
            target = "writings/TEMPLATE.org",
            template = "#+title: ${1:title}\n#+filetags: :writings:\n\n"
          }
        }
      })
    end
  }
