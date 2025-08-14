--# selene: allow(mixed_table)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Vide = require(ReplicatedStorage.packages.vide)
local px = require(ReplicatedStorage.ui.utils.px)

local App = require("./App")

local mount = Vide.mount
local create = Vide.create
local root = Vide.root

local screenGui = create("ScreenGui") {
	IgnoreGuiInset = true,
	Parent = Players.LocalPlayer.PlayerGui,
}

root(px.mount)
mount(App, screenGui)
