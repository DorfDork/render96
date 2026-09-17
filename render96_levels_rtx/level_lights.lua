gfx_rt64_set_level_lights(LEVEL_BOWSER_1, 1, {
	scene = {
		ambientBaseColor = { 50, 50, 50 },
		ambientNoGIColor = { 28, 19, 32 },
		eyeLightDiffuseColor = { 26, 26, 26 },
		eyeLightSpecularColor = { 26, 26, 26 },
		skyDiffuseMultiplier = { 1, 1, 1 },
		skyHSLModifier = { 0, 0, 0 },
		skyYawOffset = 0,
		giDiffuseStrength = 0.7,
		giSkyStrength = 0.7,
	},
	lights = {
		{
			position = { 4e+02, 8155, 11512 },
			diffuseColor = { 128, 92, 123 },
			specularColor = { 125, 99, 133 },
			attenuationRadius = 1e+11,
			pointRadius = 5e+03,
			shadowOffset = 0,
			attenuationExponent = 0,
			flickerIntensity = 0,
			groupBits = 1,
		},
	},
})

gfx_rt64_set_level_lights(LEVEL_BOWSER_3, 1, {
	scene = {
		ambientBaseColor = { 11, 11, 11 },
		ambientNoGIColor = { 30, 38, 26 },
		eyeLightDiffuseColor = { 26, 26, 26 },
		eyeLightSpecularColor = { 26, 26, 26 },
		skyDiffuseMultiplier = { 1, 1, 1 },
		skyHSLModifier = { 0, 0, 0 },
		skyYawOffset = 0,
		giDiffuseStrength = 0.7,
		giSkyStrength = 0.7,
	},
	lights = {
		{
			position = { 1e+05, 2e+05, 1e+05 },
			diffuseColor = { 128, 96, 117 },
			specularColor = { 106, 133, 99 },
			attenuationRadius = 1e+11,
			pointRadius = 5e+03,
			shadowOffset = 0,
			attenuationExponent = 0,
			flickerIntensity = 0,
			groupBits = 1,
		},
	},
})
