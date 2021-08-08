-- Global sortcut enums
-- NewFolderShortcut, EditShortcut, RenameShortcut, CopyShortcut, PasteShortcut, DeleteShortcut, EmptyTrashShortcut, EjectDiskShortcut, NewGameShortcut, RunShortcut, BuildShortcut = "New Folder", "Edit", "Rename", "Copy", "Paste", "Delete", "Empty Trash", "Eject Disk", nil, nil, nil

-- Global focus enums
WindowFocus, DesktopIconFocus, WindowIconFocus, MultipleFiles, NoFocus = 1, 2, 3, 4, 5

function WorkspaceTool:CreateDropDownMenu()

    local tmpProjectPath = ReadBiosData("ProjectTemplate")
    self.fileTemplatePath = tmpProjectPath == nil and NewWorkspacePath(ReadMetadata("RootPath", "/")).AppendDirectory(ReadMetadata("GameName", "untitled")).AppendDirectory("ProjectTemplate") or NewWorkspacePath(tmpProjectPath)

    -- print("Template Path", self.fileTemplatePath, PathExists(self.fileTemplatePath))
    -- Create some enums for the focus typess

    -- TODO need to see if the log file actually exists
    local logExits = PathExists(NewWorkspacePath("/Tmp/Log.txt"))--true

    local aboutText = "The ".. self.toolName.. " offers you access to the underlying file system. "

    if(TmpPath() ~= nil) then
        aboutText = aboutText .. "\n\nTemporary files are stores on your computer at: \n\n" .. TmpPath()
    end

    if(DocumentPath() ~= nil) then

        aboutText = aboutText .. "\n\nYou can access the 'Workspace' drive on your computer at: \n\n" .. DocumentPath()

    end

    local menuOptions =
    {
        -- About ID 1
        {name = "About", action = function() pixelVisionOS:ShowAboutModal(self.toolName, aboutText, 220) end, toolTip = "Learn about PV8."},
        -- Settings ID 2
        {name = "Settings", action = function() self:OnLaunchSettings() end, toolTip = "Configure Pixel Vision OS's Settings."},
        -- Settings ID 3
        {name = "View Log", enabled = logExits, action = function() self:OnLaunchLog() end, toolTip = "Open up the log file."},

        {divider = true},

        -- New Folder ID 5
        {name = "New Folder", action = function() self:OnNewFolder() end, key = Keys.N, enabled = false, toolTip = "Create a new file."},

        {divider = true},

        -- Edit ID 7
        -- {name = "Edit", key = Keys.E, action = OnEdit, enabled = false, toolTip = "Edit the selected file."},
        -- Edit ID 8
        {name = "Rename", action = function() self:OnRename() end, enabled = false, toolTip = "Rename the currently selected file."},
        -- Copy ID 9
        {name = "Copy", key = Keys.C, action = function() self:OnCopy() end, enabled = false, toolTip = "Copy the selected file."},
        -- Paste ID 10
        {name = "Paste", key = Keys.V, action = function() self:OnPaste() end, enabled = false, toolTip = "Paste the selected file."},
        -- Delete ID 11
        {name = "Delete", key = Keys.D, action = function() self:OnDeleteFile() end, enabled = false, toolTip = "Delete the current file."},
        {divider = true},

        -- Empty Trash ID 16
        {name = "Empty Trash", action = function() self:OnEmptyTrash() end, enabled = false, toolTip = "Delete everything in the trash."},
        -- Eject ID 17
        {name = "Eject Disk", action = function() self:OnEjectDisk() end, enabled = false, toolTip = "Eject the currently selected disk."},
        -- Shutdown ID 18
        {name = "Shutdown", action = function() self:OnShutdown() end, toolTip = "Shutdown PV8."} -- Quit the current game
    }

    local addAt = 6

    if(PathExists(self.fileTemplatePath) == true) then

        table.insert(menuOptions, addAt, {name = "New Project", key = Keys.P, action = function() self:OnNewProject() end, enabled = false, toolTip = "Create a new file."})

        -- NewGameShortcut = "New Project"

        addAt = addAt + 1

        -- print("New Project")

    end

    self.newFileOptions = {}

    -- TODO this should be done better

    -- if(runnerName == DrawVersion or runnerName == TuneVersion) then

    table.insert(menuOptions, addAt, {name = "New Text", action = function() self:OnNewFile("untitled", "txt", "data", false) end, enabled = false, toolTip = "Create an empty text file."})
    table.insert(self.newFileOptions, {name = "New Text"})
    addAt = addAt + 1

    -- end

    -- print("Code Exists ", self.fileTemplatePath.AppendFile("code.lua"), self.fileTemplatePath)
    -- Add text options to the menu
    -- if(runnerName ~= PlayVersion and runnerName ~= DrawVersion and runnerName ~= TuneVersion) then
    -- if(PathExists(self.fileTemplatePath.AppendFile("code.lua"))) then
    
    -- end

    -- if(PathExists(self.fileTemplatePath.AppendFile("json.json"))) then
    table.insert(menuOptions, addAt, {name = "New JSON", action = function() self:OnNewFile("untitled", "json") end, enabled = false, toolTip = "Create an empty JSON file."})
    table.insert(self.newFileOptions, {name = "New JSON"})
    addAt = addAt + 1

    table.insert(menuOptions, addAt, {name = "New Code", action = function() self:CreateNewCodeFile() end, enabled = false, toolTip = "Create a new code file."})
    table.insert(self.newFileOptions, {name = "New Code"})
    addAt = addAt + 1
    -- end

    -- Add draw options

    -- if(PathExists(self.fileTemplatePath.AppendFile("colors.png"))) then
        table.insert(menuOptions, addAt, {name = "New Colors", action = function() self:OnNewFile("colors", "png", "colors", false) end, enabled = false, toolTip = "Create a new color file.", file = "colors.png"})
        table.insert(self.newFileOptions, {name = "New Colors", file = "colors.png"})
        addAt = addAt + 1
    -- end

    -- if(PathExists(self.fileTemplatePath.AppendFile("sprite.png"))) then
        table.insert(menuOptions, addAt, {name = "New Sprite", action = function() self:OnNewFile("sprite", "png", "sprite") end, enabled = false, toolTip = "Create a new sprite.", file = "sprite.png"})
        table.insert(self.newFileOptions, {name = "New Sprite", file = "sprite.png"})
        addAt = addAt + 1
    -- end

    -- if(PathExists(self.fileTemplatePath.AppendFile("large.font.png"))) then

        table.insert(menuOptions, addAt, {name = "New Font", action = function() self:OnNewFile("untitled", "font.png", "font") end, enabled = false, toolTip = "Create a new font."})
        table.insert(self.newFileOptions, {name = "New Font"})
        addAt = addAt + 1

    -- end

    -- if(PathExists(self.fileTemplatePath.AppendFile("tilemap.json"))) then

        table.insert(menuOptions, addAt, {name = "New Tilemap", action = function() self:OnNewFile("tilemap", "png", "tilemap", false) end, enabled = false, toolTip = "Create a new Tilemap.", file = "tilemap.png"})
        table.insert(self.newFileOptions, {name = "New Tilemap", file = "tilemap.png"})
        addAt = addAt + 1

    -- end

    -- Add music options

    if(PathExists(self.fileTemplatePath.AppendFile("sounds.json"))) then

        table.insert(menuOptions, addAt, {name = "New Sounds", action = function() self:OnNewFile("sounds", "json", "sounds", false) end, enabled = false, toolTip = "Create a new sound file.", file = "sounds.json"})
        table.insert(self.newFileOptions, {name = "New Sounds", file = "sounds.json"})
        addAt = addAt + 1
    end

    if(PathExists(self.fileTemplatePath.AppendFile("music.json"))) then

        table.insert(menuOptions, addAt, {name = "New Music", action = function() self:OnNewFile("music", "json", "music", false) end, enabled = false, toolTip = "Create a new music file.", file = "music.json"})
        table.insert(self.newFileOptions, {name = "New Music", file = "music.json"})
        addAt = addAt + 1

    end

    -- if(PathExists(self.currentPath.AppendFile("code.lua")) or PathExists(self.currentPath.AppendFile("code.cs"))) then

        -- print("GAME")
        -- TODO need to add to the offset
        addAt = addAt + 6

        -- Empty Trash ID 13
        table.insert(menuOptions, addAt, {name = "Run", key = Keys.R, action = function() self:OnRun() end, enabled = false, toolTip = "Run the current game."})
        addAt = addAt + 1

        table.insert(menuOptions, addAt, {name = "Build", action = function() self:ExportGame() end, enabled = false, toolTip = "Create a PV8 file from the current game."})
        addAt = addAt + 1

        table.insert(menuOptions, addAt, {divider = true})
        addAt = addAt + 1

        RunShortcut = "Run"
        BuildShortcut = "Build"

    -- end

    pixelVisionOS:CreateTitleBarMenu(menuOptions, "See menu options for this tool.")

end

function WorkspaceTool:ExportGame()

    pixelVisionOS:OnExportGame(
        self.currentPath,
        function (value)
            self:OnBuildGameClose(value)
        end
    )

end

function WorkspaceTool:OnBuildGameClose(response)

    local response = ReadExportMessage()
    local success = response.DiskExporter_success
    local message = response.DiskExporter_message
    local path = response.DiskExporter_path

    if(success == true) then
        self:OpenWindow(NewWorkspacePath(path).ParentPath)
    end

end

function WorkspaceTool:CreateNewCodeFile(defaultPath)

    local templatePath = NewWorkspacePath(ReadMetadata("RootPath", "/")).AppendDirectory(ReadMetadata("GameName", "untitled")).AppendDirectory("CodeTemplates")

    defaultPath = defaultPath or self.currentPath

    local fileName = "code"
    local ext = ".lua"

    local infoFilePath = (defaultPath.EntityName == "Src" and defaultPath.ParentPath or defaultPath).AppendFile("info.json")

    if(PathExists(infoFilePath)) then

        local data = ReadJson(infoFilePath)

        -- print(dump(data))

        if(data["runnerType"] ~= nil) then
            ext = data["runnerType"] ~= "lua" and  ".cs" or ".lua"
        end

    elseif(PathExists(defaultPath.AppendFile("code.cs"))) then

        ext = ".cs"

    end

    local empty = PathExists(defaultPath.AppendFile(fileName .. ext))

    -- print("Create new code file at", defaultPath, fileName, ext)

    if(empty ~= true) then

        local newPath = defaultPath.AppendFile(fileName .. ext)

        -- print("Create file", templatePath.AppendFile("main-" .. fileName .. ext), "in", defaultPath.AppendFile(fileName .. ext))

        CopyTo(templatePath.AppendFile("main-" .. fileName .. ext), newPath)

        self:RefreshWindow(true)

        self:SelectFile(newPath)

    else

        local newFileModal = self:GetNewFileModal()

        newFileModal:SetText("New " .. (ext == ".cs" and "C# File" or "Lua"), "code", "Name code file", true)

        pixelVisionOS:OpenModal(newFileModal,
            function()

                -- Check to see if ok was pressed on the model
                if(newFileModal.selectionValue == true) then

                    local newPath = UniqueFilePath(defaultPath.AppendFile(newFileModal.inputField.text .. ext))
                    
                    local templatePath = templatePath.AppendFile("empty-" .. fileName .. ext)

                    -- TODO if this is a C# file, we need to rename the class
                    if(ext == ".cs") then

                        local codeTemplate = ReadTextFile(templatePath)

                        local newClassName = newPath.EntityNameWithoutExtension:sub(1,1):upper() .. newPath.EntityNameWithoutExtension:gsub('%W',' '):gsub("%W%l", string.upper):sub(2):gsub('%W','') .. "Class"

                        codeTemplate = codeTemplate:gsub( "CustomClass", newClassName)


                        -- print("newClassName", newClassName)
                        
                        SaveTextToFile(newPath, codeTemplate)


                    else

                        -- Just copy the Lua template as is
                        CopyTo(templatePath, newPath)

                    end

                    
                    self:RefreshWindow(true)

                    self:SelectFile(newPath)

                end

            end
        )   

        -- self:OnNewFile("code", "lua")
    end

end

function WorkspaceTool:OnEjectDisk()

    -- Get all of the selected  files
    local selections = self:CurrentlySelectedFiles()
    
    -- If there is more than one selection, exit
    if(#selections > 1) then
        return
    end

    -- Get the first selection
    local currentSelection = self.files[selections[1]]
    
    -- Make sure that the selection is a disk
    if(currentSelection.type ~= "disk") then
        
        return
    end
        
    local buttons = 
    {
        {
            name = "modalyesbutton",
            action = function(target)
                target.onParentClose()
                EjectDisk(currentSelection.path)
            end,
            key = Keys.Enter,
            tooltip = "Press 'enter' to reset mapping to the default value"
        },
        {
            name = "modalnobutton",
            action = function(target)
                target.onParentClose()
            end,
            key = Keys.Escape,
            tooltip = "Press 'esc' to avoid making any changes"
        }
    }

    -- Ask before ejecting a disk
    pixelVisionOS:ShowMessageModal("Eject Disk", "Do you want to eject the '".. currentSelection.name .."'disk?", 160, buttons)

end


function WorkspaceTool:UpdateContextMenu()

    -- print("UpdateContextMenu")

    local selections = self:CurrentlySelectedFiles()

    local specialDir = self.currentPath.EntityName == "Sprites" or self.currentPath.EntityName == "Src" or self.currentPath.EntityName == "Tilemaps"


    -- print("selections", dump(selections))
    -- Check to see if currentPath is a game
    local canRun = self.focus == true and self.isGameDir and specialDir == false--and pixelVisionOS:ValidateGameInDir(self.currentPath, {"code.lua"})-- and selections

    -- if(canRun) then

    --     if(self.runnerType == "csharp" and PathExists(self.currentPath.AppendFile("code.cs"))) then
    --         canRun = true
    --     elseif(self.runnerType == "lua" and PathExists(self.currentPath.AppendFile("lua.cs"))) then
    --         canRun = true
    --     else
    --         canRun = false
    --     end

    -- end

    -- Look to see if the selection is a special file (parent dir or run)
    local specialFile = false

    -- Get the first file which is the current selection
    local currentSelection = nil

    if(selections ~= nil) then

        -- print("self.files", #self.files)
        currentSelection = self.files[selections[1]]
        -- print("self.totalSingleSelectFiles", self.totalSingleSelectFiles)
        for i = 1, #selections do

            local tmpFile = self.files[selections[i]]
            
            -- print("tmpFile", tmpFile.name, tmpFile.type)

            if(tmpFile.type == "installer" or tmpFile.type == "updirectory" or tmpFile.type == "run" or tmpFile.type == "trash" or tmpFile.type == "drive" or tmpFile.type == "disk" ) then
                specialFile = true
                break
            end

        end

    end

    local trashOpen = self:TrashOpen()

    -- print("currentSelection", currentSelection.type)

    -- Test to see if you can rename
    local canEdit = self.focus == true and selections ~= nil and #selections == 1 and specialFile == false and trashOpen == false

    local canEject = self.focus == false and specialFile == true and currentSelection.type == "disk"

    local canCreateFile = self.focus == true and trashOpen == false

    local canCreateFolder = canCreateFile == true and specialDir == false


    local canCreateProject = canCreateFolder == true and canRun == false
    
    local canBuild = canRun == true and string.starts(self.currentPath.Path, "/Disks/") == false and specialDir == false

    local canCopy = self.focus == true and selections ~= nil and #selections > 0 and specialFile == false and trashOpen == false
    local canPaste = canCreateFile == true and pixelVisionOS:ClipboardFull() == true and string.starts(GetClipboardText(), "paths:")

    pixelVisionOS:EnableMenuItemByName("Rename", canEdit)

    pixelVisionOS:EnableMenuItemByName("Copy", canCopy)

    pixelVisionOS:EnableMenuItemByName("Paste", canPaste)

    pixelVisionOS:EnableMenuItemByName("Delete", canCopy)

    pixelVisionOS:EnableMenuItemByName("Build", canBuild)

    pixelVisionOS:EnableMenuItemByName("New Project", canCreateProject)

    pixelVisionOS:EnableMenuItemByName("New Folder", canCreateFolder)

    pixelVisionOS:EnableMenuItemByName("Run", canRun)

    pixelVisionOS:EnableMenuItemByName("Empty Trash", #GetEntities(self.trashPath) > 0)

    pixelVisionOS:EnableMenuItemByName("Eject", canEject)

    -- Loop through all the file creation options
    for i = 1, #self.newFileOptions do

        -- Get the new file option data
        local option = self.newFileOptions[i]

        local enable = canCreateFile and specialDir == false

        -- Check to see if the option should be enabled
        if(enable and option.file ~= nil) then

            -- Change the enable flag based on if the file exists
            enable = not PathExists(self.currentPath.AppendFile(option.file))

        end

        -- Enable the file in the menu
        pixelVisionOS:EnableMenuItemByName(option.name, enable)

    end

    -- pixelVisionOS:EnableMenuItemByName("New Sprite", false)

    -- Manually enable files base on special dir
    if(specialDir == true) then
        
        if(self.currentPath.EntityName == "Src") then
            
            -- Enable the file in the menu
            pixelVisionOS:EnableMenuItemByName("New Code", true)

        elseif(self.currentPath.EntityName == "Sprites") then

            -- Enable the file in the menu
            pixelVisionOS:EnableMenuItemByName("New Sprite", true)

        elseif(self.currentPath.EntityName == "Tilemaps") then

            -- Enable the file in the menu
            pixelVisionOS:EnableMenuItemByName("New Tilemap", true)

        end
        
    else

        -- Need to manually disable the new sprite option
        -- if(PathExists(self.currentPath.AppendFile("sprites.png"))) then
        pixelVisionOS:EnableMenuItemByName("New Sprite", false)
        pixelVisionOS:EnableMenuItemByName("New Tilemap", false)
        pixelVisionOS:EnableMenuItemByName("New Font", self.isGameDir)
        pixelVisionOS:EnableMenuItemByName("New Music", self.isGameDir)
        pixelVisionOS:EnableMenuItemByName("New Sounds", self.isGameDir)
        pixelVisionOS:EnableMenuItemByName("New Colors", self.isGameDir)
        -- end

    end

end

function WorkspaceTool:ToggleOptions(enabled)

    -- Loop through all the file creation options
    for i = 1, #self.newFileOptions do

        -- Get the new file option data
        local option = self.newFileOptions[i]

        -- Check to see if the option should be enabled
        if(enabled == true and option.file ~= nil) then

            -- Change the enable flag based on if the file exists
            enabled = not PathExists(self.currentPath.AppendFile(option.file))

        end

        -- Enable the file in the menu
        pixelVisionOS:EnableMenuItemByName(option.name, enabled)

    end

end


function WorkspaceTool:OnMenuQuit()

    QuitCurrentTool()

end

function WorkspaceTool:OnLaunchSettings()

    local editorPath = ReadBiosData("SettingsEditor")

    if(editorPath == nil) then
        editorPath = self.rootPath .."SettingsTool/"
    end

    LoadGame(editorPath)

end

function WorkspaceTool:OnLaunchLog()

    -- Get a list of all the editors
    local editorMapping = pixelVisionOS:FindEditors()

    -- Find the json editor
    textEditorPath = editorMapping["txt"]

    local metaData = {
        directory = "/Tmp/",
        file = "/Tmp/Log.txt"
    }

    LoadGame(textEditorPath, metaData)

end

function WorkspaceTool:OnShutdown()

    self:CancelFileActions()

    local buttons = 
    {
        {
            name = "modalyesbutton",
            action = function(target)
                target.onParentClose()
                ShutdownSystem()
                -- Save changes
                self.shuttingDown = true
            end,
            key = Keys.Enter,
            tooltip = "Press 'enter' to reset mapping to the default value"
        },
        {
            name = "modalnobutton",
            action = function(target)
                target.onParentClose()
            end,
            key = Keys.Escape,
            tooltip = "Press 'esc' to avoid making any changes"
        }
    }

    pixelVisionOS:ShowMessageModal("Shutdown " .. self.runnerName, "Are you sure you want to shutdown "..self.runnerName.."?", 160, buttons)

end