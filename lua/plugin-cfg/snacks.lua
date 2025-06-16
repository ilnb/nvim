local M = {}

M.keys = {
  {
    "<leader>dd",
    function()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].ft == "snacks_dashboard" then
          if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
          return
        end
      end
      require("snacks").dashboard()
    end,
    desc = "Dashboard",
  },
  { "<leader>n", function() Snacks.picker.notifications() end,  desc = "Notifications" },
  { "<leader>N", function() Snacks.notifier.show_history() end, desc = "Notification history" },
  -- { "<leader>bd", function() M.bufdelete() end,      desc = "Delete buffer", }
}

---@type snacks.Config
M.opts = {
  indent = {
    scope = { enabled = false }
  },
  statuscolumn = {
    left = { "fold", "mark" },
    right = { "sign", "git" },
    folds = { open = true },
  },
  dashboard = {
    sections = {
      {
        header =
        --[[
       ⢀⣴⡾⠃⠄⠄⠄⠄⠄⠈⠺⠟⠛⠛⠛⠛⠻⢿⣿⣿⣿⣿⣶⣤⡀
     ⢀⣴⣿⡿⠁⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣸⣿⣿⣿⣿⣿⣿⣿⣷
    ⣴⣿⡿⡟⡼⢹⣷⢲⡶⣖⣾⣶⢄⠄⠄⠄⠄⠄⢀⣼⣿⢿⣿⣿⣿⣿⣿⣿⣿
   ⣾⣿⡟⣾⡸⢠⡿⢳⡿⠍⣼⣿⢏⣿⣷⢄⡀⠄⢠⣾⢻⣿⣸⣿⣿⣿⣿⣿⣿⣿
 ⣡⣿⣿⡟⡼⡁⠁⣰⠂⡾⠉⢨⣿⠃⣿⡿⠍⣾⣟⢤⣿⢇⣿⢇⣿⣿⢿⣿⣿⣿⣿⣿
⣱⣿⣿⡟⡐⣰⣧⡷⣿⣴⣧⣤⣼⣯⢸⡿⠁⣰⠟⢀⣼⠏⣲⠏⢸⣿⡟⣿⣿⣿⣿⣿⣿
⣿⣿⡟⠁⠄⠟⣁⠄⢡⣿⣿⣿⣿⣿⣿⣦⣼⢟⢀⡼⠃⡹⠃⡀⢸⡿⢸⣿⣿⣿⣿⣿⡟
⣿⣿⠃⠄⢀⣾⠋⠓⢰⣿⣿⣿⣿⣿⣿⠿⣿⣿⣾⣅⢔⣕⡇⡇⡼⢁⣿⣿⣿⣿⣿⣿⢣
⣿⡟⠄⠄⣾⣇⠷⣢⣿⣿⣿⣿⣿⣿⣿⣭⣀⡈⠙⢿⣿⣿⡇⡧⢁⣾⣿⣿⣿⣿⣿⢏⣾
⣿⡇⠄⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⢻⠇⠄⠄⢿⣿⡇⢡⣾⣿⣿⣿⣿⣿⣏⣼⣿
⣿⣷⢰⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⢰⣧⣀⡄⢀⠘⡿⣰⣿⣿⣿⣿⣿⣿⠟⣼⣿⣿
⢹⣿⢸⣿⣿⠟⠻⢿⣿⣿⣿⣿⣿⣿⣿⣶⣭⣉⣤⣿⢈⣼⣿⣿⣿⣿⣿⣿⠏⣾⣹⣿⣿
⢸⠇⡜⣿⡟⠄⠄⠄⠈⠙⣿⣿⣿⣿⣿⣿⣿⣿⠟⣱⣻⣿⣿⣿⣿⣿⠟⠁⢳⠃⣿⣿⣿
 ⣰⡗⠹⣿⣄⠄⠄⠄⢀⣿⣿⣿⣿⣿⣿⠟⣅⣥⣿⣿⣿⣿⠿⠋  ⣾⡌⢠⣿⡿⠃
⠜⠋⢠⣷⢻⣿⣿⣶⣾⣿⣿⣿⣿⠿⣛⣥⣾⣿⠿⠟⠛⠉
]]

        [[
⣇⣿⠘⣿⣿⣿⡿⡿⣟⣟⢟⢟⢝⠵⡝⣿⡿⢂⣼⣿⣷⣌⠩⡫⡻⣝⠹⢿⣿⣿
⡆⣿⣆⠱⣝⡵⣝⢅⠙⣿⢕⢕⢕⢕⢝⣥⢒⠅⣿⣿⣿⡿⣳⣌⠪⡪⣡⢑⢝⣇
⡆⣿⣿⣦⠹⣳⣳⣕⢅⠈⢗⢕⢕⢕⢕⢕⢈⢆⠟⠋⠉⠁⠉⠉⠁⠈⠼⢐⢕⢽
⡗⢰⣶⣶⣦⣝⢝⢕⢕⠅⡆⢕⢕⢕⢕⢕⣴⠏⣠⡶⠛⡉⡉⡛⢶⣦⡀⠐⣕⢕
⡝⡄⢻⢟⣿⣿⣷⣕⣕⣅⣿⣔⣕⣵⣵⣿⣿⢠⣿⢠⣮⡈⣌⠨⠅⠹⣷⡀⢱⢕
⡝⡵⠟⠈⢀⣀⣀⡀⠉⢿⣿⣿⣿⣿⣿⣿⣿⣼⣿⢈⡋⠴⢿⡟⣡⡇⣿⡇⡀⢕
⡝⠁⣠⣾⠟⡉⡉⡉⠻⣦⣻⣿⣿⣿⣿⣿⣿⣿⣿⣧⠸⣿⣦⣥⣿⡇⡿⣰⢗⢄
⠁⢰⣿⡏⣴⣌⠈⣌⠡⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣬⣉⣉⣁⣄⢖⢕⢕⢕
⡀⢻⣿⡇⢙⠁⠴⢿⡟⣡⡆⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣵⣵⣿
⡻⣄⣻⣿⣌⠘⢿⣷⣥⣿⠇⣿⣿⣿⣿⣿⣿⠛⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣷⢄⠻⣿⣟⠿⠦⠍⠉⣡⣾⣿⣿⣿⣿⣿⣿⢸⣿⣦⠙⣿⣿⣿⣿⣿⣿⣿⣿⠟
⡕⡑⣑⣈⣻⢗⢟⢞⢝⣻⣿⣿⣿⣿⣿⣿⣿⠸⣿⠿⠃⣿⣿⣿⣿⣿⣿⡿⠁⣠
⡝⡵⡈⢟⢕⢕⢕⢕⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⣿⣿⠿⠋⣀⣈⠙
⡝⡵⡕⡀⠑⠳⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⢉⡠⡲⡫⡪⡪⡣
]]

        --[[
⣿⣿⣷⡁⢆⠈⠕⢕⢂⢕⢂⢕⢂⢔⢂⢕⢄⠂⣂⠂⠆⢂⢕⢂⢕⢂⢕⢂⢕⢂
⣿⣿⣿⡷⠊⡢⡹⣦⡑⢂⢕⢂⢕⢂⢕⢂⠕⠔⠌⠝⠛⠶⠶⢶⣦⣄⢂⢕⢂⢕
⣿⣿⠏⣠⣾⣦⡐⢌⢿⣷⣦⣅⡑⠕⠡⠐⢿⠿⣛⠟⠛⠛⠛⠛⠡⢷⡈⢂⢕⢂
⠟⣡⣾⣿⣿⣿⣿⣦⣑⠝⢿⣿⣿⣿⣿⣿⡵⢁⣤⣶⣶⣿⢿⢿⢿⡟⢻⣤⢑⢂
⣾⣿⣿⡿⢟⣛⣻⣿⣿⣿⣦⣬⣙⣻⣿⣿⣷⣿⣿⢟⢝⢕⢕⢕⢕⢽⣿⣿⣷⣔
⣿⣿⠵⠚⠉⢀⣀⣀⣈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣗⢕⢕⢕⢕⢕⢕⣽⣿⣿⣿⣿
⢷⣂⣠⣴⣾⡿⡿⡻⡻⣿⣿⣴⣿⣿⣿⣿⣿⣿⣷⣵⣵⣵⣷⣿⣿⣿⣿⣿⣿⡿
⢌⠻⣿⡿⡫⡪⡪⡪⡪⣺⣿⣿⣿⣿⣿⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃
⠣⡁⠹⡪⡪⡪⡪⣪⣾⣿⣿⣿⣿⠋⠐⢉⢍⢄⢌⠻⣿⣿⣿⣿⣿⣿⣿⣿⠏⠈
⡣⡘⢄⠙⣾⣾⣾⣿⣿⣿⣿⣿⣿⡀⢐⢕⢕⢕⢕⢕⡘⣿⣿⣿⣿⣿⣿⠏⠠⠈
⠌⢊⢂⢣⠹⣿⣿⣿⣿⣿⣿⣿⣿⣧⢐⢕⢕⢕⢕⢕⢅⣿⣿⣿⣿⡿⢋⢜⠠⠈
⠄⠁⠕⢝⡢⠈⠻⣿⣿⣿⣿⣿⣿⣿⣷⣕⣑⣑⣑⣵⣿⣿⣿⡿⢋⢔⢕⣿⠠⠈
⠨⡂⡀⢑⢕⡅⠂⠄⠉⠛⠻⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢋⢔⢕⢕⣿⣿⠠⠈
⠄⠪⣂⠁⢕⠆⠄⠂⠄⠁⡀⠂⡀⠄⢈⠉⢍⢛⢛⢛⢋⢔⢕⢕⢕⣽⣿⣿⠠⠈
]]

        --[[
⣿⡇⣿⣿⣿⠛⠁⣴⣿⡿⠿⠧⠹⠿⠘⣿⣿⣿⡇⢸⡻⣿⣿⣿⣿⣿⣿⣿
⢹⡇⣿⣿⣿⠄⣞⣯⣷⣾⣿⣿⣧⡹⡆⡀⠉⢹⡌⠐⢿⣿⣿⣿⡞⣿⣿⣿
⣾⡇⣿⣿⡇⣾⣿⣿⣿⣿⣿⣿⣿⣿⣄⢻⣦⡀⠁⢸⡌⠻⣿⣿⣿⡽⣿⣿
⡇⣿⠹⣿⡇⡟⠛⣉⠁⠉⠉⠻⡿⣿⣿⣿⣿⣿⣦⣄⡉⠂⠈⠙⢿⣿⣝⣿
⠤⢿⡄⠹⣧⣷⣸⡇⠄⠄⠲⢰⣌⣾⣿⣿⣿⣿⣿⣿⣶⣤⣤⡀⠄⠈⠻⢮
  ⣧⠄⢘⢻⣿⡇⢀⣀⠄⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⡀⠄⢀
  ⣿⡆⢸⣿⣿⣿⣬⣭⣴⣿⣿⣿⣿⣿⣿⣿⣯⠝⠛⠛⠙⢿⡿⠃⠄⢸
  ⢿⣿⡀⣿⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣿⣿⣿⣿⡾⠁⢠⡇⢀
  ⢸⣿⡇⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣏⣫⣻⡟⢀⠄⣿⣷⣾
  ⢸⣿⡇⠄⠈⠙⠿⣿⣿⣿⣮⣿⣿⣿⣿⣿⣿⣿⣿⡿⢠⠊⢀⡇⣿⣿
   ⣿⡇⢀⡲⠄⠄⠈⠙⠻⢿⣿⣿⠿⠿⠟⠛⠋⠁⣰⠇ ⢸⣿⣿⣿
   ⣿⡇⢬⡻⡇⡄⠄⠄⠄⡰⢖⠔⠉⠄⠄⠄⠄⣼⠏  ⢸⣿⣿⣿
   ⣿⡇⠄⠙⢌⢷⣆⡀⡾⡣⠃⠄⠄⠄⠄⠄⣼⡟    ⢿⣿⣿
]]

        --[[
⡿⠋⠄⣀⣀⣤⣴⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣌⠻⣿⣿
⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠹⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠹
⣿⣿⡟⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡛⢿⣿⣿⣿⣮⠛⣿⣿⣿⣿⣿⣿⡆
⡟⢻⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣣⠄⡀⢬⣭⣻⣷⡌⢿⣿⣿⣿⣿⣿
⠃⣸⡀⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠈⣆⢹⣿⣿⣿⡈⢿⣿⣿⣿⣿
⠄⢻⡇⠄⢛⣛⣻⣿⣿⣿⣿⣿⣿⣿⣿⡆⠹⣿⣆⠸⣆⠙⠛⠛⠃⠘⣿⣿⣿⣿
⠄⠸⣡⠄⡈⣿⣿⣿⣿⣿⣿⣿⣿⠿⠟⠁⣠⣉⣤⣴⣿⣿⠿⠿⠿⡇⢸⣿⣿⣿
⠄⡄⢿⣆⠰⡘⢿⣿⠿⢛⣉⣥⣴⣶⣿⣿⣿⣿⣻⠟⣉⣤⣶⣶⣾⣿⡄⣿⡿⢸
⠄⢰⠸⣿⠄⢳⣠⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣼⣿⣿⣿⣿⣿⣿⡇⢻⡇⢸
⢷⡈⢣⣡⣶⠿⠟⠛⠓⣚⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⢸⠇⠘
⡀⣌⠄⠻⣧⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠛⠛⠛⢿⣿⣿⣿⣿⣿⡟⠘⠄⠄
⣷⡘⣷⡀⠘⣿⣿⣿⣿⣿⣿⣿⣿⡋⢀⣠⣤⣶⣶⣾⡆⣿⣿⣿⠟⠁⠄⠄⠄⠄
⣿⣷⡘⣿⡀⢻⣿⣿⣿⣿⣿⣿⣿⣧⠸⣿⣿⣿⣿⣿⣷⡿⠟⠉⠄⠄⠄⠄⡄⢀
⣿⣿⣷⡈⢷⡀⠙⠛⠻⠿⠿⠿⠿⠿⠷⠾⠿⠟⣛⣋⣥⣶⣄⠄⢀⣄⠹⣦⢹⣿
]]

        --[[
⣾⣿⡇⢸⣿⣿⣿⠄⠈⣿⣿⣿⣿⠈⣿⡇⢹⣿⣿⣿⡇⡇⢸⣿⣿⡇⣿⣿⣿
⣿⣿⡇⢸⣿⣿⣿⡇⠄⢹⣿⣿⣿⡀⣿⣧⢸⣿⣿⣿⠁⡇⢸⣿⣿⠁⣿⣿⣿
⣿⣿⡇⠸⣿⣿⣿⣿⡄⠈⢿⣿⣿⡇⢸⣿⡀⣿⣿⡿⠸⡇⣸⣿⣿⠄⣿⣿⣿
⣿⡿⠷⠄⠿⠿⠿⠟⠓⠰⠘⠿⣿⣿⡈⣿⡇⢹⡟⠰⠦⠁⠈⠉⠋⠄⠻⢿⣿
⡑⠶⡏⠛⠐⠋⠓⠲⠶⣭⣤⣴⣦⣭⣥⣮⣾⣬⣴⡮⠝⠒⠂⠂⠘⠉⠿⠖⣬
⠉⠄⡀⠄⣀⣀⣀⣀⠈⢛⣿⣿⣿⣿⣿⣿⣿⣿⣟⠁⣀⣤⣤⣠⡀⠄⡀⠈⠁
⠠⣾⡀⣾⣿⣧⣼⣿⡿⢠⣿⣿⣿⣿⣿⣿⣿⣿⣧⣼⣿⣧⣼⣿⣿⢀⣿⡇⠄
⠄⠻⣷⡘⢿⣿⣿⡿⢣⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣜⢿⣿⣿⡿⢃⣾⠟⢁⠈
⢻⣶⣬⣿⣶⣬⣥⣶⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⣷⣶⣶⣾⣿⣷⣾⣾⢣
⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠘
⡐⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⢠⢃
⣷⡀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⡿⠋⢀⠆⣼
⣿⣷⡀⠄⠈⠛⢿⣿⣿⣿⣿⣷⣶⣶⣶⣶⣶⣿⣿⣿⣿⣿⠿⠋⠠⠂⢀⣾⣿
⣿⣿⣧⠄⠄⢵⢠⣈⠛⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⢋⡁⢰⠏⠄⠄⣼⣿⣿
⣿⣿⣿⡄⢢⠨⠄⣯⠄⠄⣌⣉⠛⠻⠟⠛⢋⣉⣤⠄⢸⡇⣨⣤⠄⢸⣿⣿⣿
]]

        --[[
          ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
      ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z
    ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z
  ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z
███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝
]]
      },
      {
        icon = "󱌣 ",
        title = "Actions",
        indent = 2,
        padding = 1,
        { icon = " ", desc = "Find file", key = "f", action = ":lua require('fzf-lua').files({fd_opts = '-I -t f -E .git -H'})" }, --action = "<leader><Space>"
        { icon = "󰒲 ", desc = "Lazy", key = "l", action = ":Lazy" },
        { icon = " ", desc = "Lazy Extras", key = "x", action = ":LazyExtras" },
        { icon = " ", desc = "Exit", key = "q", action = ":q" },
      },
      { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
      {
        icon = " ",
        title = "Projects",
        indent = 2,
        padding = 1,
        {
          icon = "󰉋 ",
          desc = "Data Structure",
          key = "d",
          action = function()
            require("fzf-lua").files({
              cwd = "~/data structure/",
              actions = {
                ["default"] = function(selected, opts)
                  if selected and #selected > 0 then
                    vim.cmd("tcd ~/data structure/")
                    require("fzf-lua").actions.file_edit_or_qf(selected, opts)
                  end
                end
              }
            })
          end
        },
        { icon = "󰙱 ", desc = "C Codes", key = "c", action = ":lua require('fzf-lua').files({ cwd = '~/code/'})" },
        {
          icon = "󰙲 ",
          desc = "C++ Codes",
          key = "p",
          action = function()
            require("fzf-lua").files({
              cwd = "~/code/cpp/",
              actions = {
                ["default"] = function(selected, opts)
                  if selected and #selected > 0 then
                    vim.cmd("tcd ~/code/cpp/")
                    require("fzf-lua").actions.file_edit_or_qf(selected, opts)
                  end
                end
              }
            })
          end
        },
        {
          icon = "󰙱 ",
          desc = "Raylib",
          key = "r",
          action = function()
            require("fzf-lua").files({
              cwd = "~/raylib/",
              -- fd_opts = "--no-ignore --type file --exclude .git --hidden",
              fd_opts = "-I -t f -E .git -H",
              actions = {
                ["default"] = function(selected, opts)
                  if selected and #selected > 0 then
                    vim.cmd("tcd ~/raylib/")
                    require("fzf-lua").actions.file_edit_or_qf(selected, opts)
                  end
                end
              }
            })
          end
        },
        {
          icon = "",
          desc = "Lua Codes",
          key = "L",
          action = function()
            require("fzf-lua").files({
              cwd = "~/code/lua/",
              actions = {
                ["default"] = function(selected, opts)
                  if selected and #selected > 0 then
                    vim.cmd("tcd ~/code/lua/")
                    require("fzf-lua").actions.file_edit_or_qf(selected, opts)
                  end
                end
              }
            })
          end
        },
      },
      { section = "startup" },
    },
    formats = {
      key = function(item)
        --return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
        return { { "⟦", hl = "special" }, { item.key, hl = "key" }, { "⟧", hl = "special" } }
      end,
    },
  },
}

return M
