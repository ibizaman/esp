Plus one for being able to use a raspi as the gateway/hub/controller of your setup. I spent the last three days doing exactly that and it seems to work mostly as advertised. But honestly, it's a big pain to set up and not super newbie-friendly as a process.

My adventure, incase it helps you make better life choices:
Zigbee radio

I bought a generic CC2531 stick (super cheap usb-to-zigbee thingy as also suggested by u/TheSmartHomeJourney - his blog post is great!) from AliExpress. That requires a bit of wiring and command line tinkering to flash the right software into with your raspi. You can get these pre-flashed or get more expensive models that supposedly make life easier, but I was a cheap-ass.
Home Assistant

Seems like everyone around me was recommending HA as the automation software, so I went with that. After a few days of intensive tinkering, I kinda hate the experience, but at the end of the day, it delivers. I again made my life difficult by running HA via Docker (since I have other things going on in my raspi and manage everything via BalenaOS) and, as it turns out, HA becomes a bit lame in that mode and the documentation is confusing at best.

Short version: HA used to be called HASS.IO and a bunch of stuff (code, docs, blogs...) still references that era in the universe. Nowadays HA is three separate products: Home Assistant Cloud, Home Assistant, and Home Assistant Core. The middle one is what you'd usually install on your raspi (basically it takes over your raspi to manage "add-ons" and stuff) and HA Core is what I have when running in a container. HA Core will do all the important stuff, but you will have to figure out how to install and configure all the software AROUND Home Assistant to actually make it play ball. Doable, but pick your poison.
Software Dependencies

It took a while for me to understand, but the happy path of making things work is not for HA to interface with the CC2531 (or whatever you have) directly. It can do that, but in real life Zigbee devices do not work in a very standard way and basically HA doesn't know what to do with a bunch of them. What you instead want to do, is install some piece of software in the middle that handles the problem for you.

Some Zigbee USB sticks seem to come with their own software, but I ended up installing "zigbee2mqtt". It's an excellent piece of code that manages your Zigbee radio, identifies the actual devices you have, and exposes those capabilities onwards in a way that Home Assistant can understand. It's great and the supported device list is huge: https://www.zigbee2mqtt.io/information/supported_devices.html

As the name implies you are now talking in a protocol called MQTT instead of Zigbee. For this to work, you need to have what's called an MQTT broker running somewhere. A software called "mosquitto" is recommended by everyone and works great.

I had some issues with removing and pairing devices again and in general, understanding what was going on with my Zigbee network. Installing "zigbee2mqttAssistant" helped out. It's basically yet another software that hosts a website that lets you see what's going on with zigbee2mqtt and poke it a little bit, like force removing devices from my Zigbee network to pair them again.
Recap

    Devices talk over Zigbee to each other and finally to your CC2531 (or similar) usb dongle.

    CC2531 is controlled by zigbee2mqtt (runs in a docker container in my raspi)

    zigbee2mqttAssistant talks to zigbee2mqtt and me (runs in a docker container in my raspi)

    zigbee2mqtt talks to mosquitto (runs in a docker container in my raspi) over MQTT

    Home Assistant's (runs in a docker container in my raspi) MQTT integration also talks to mosquitto over MQTT

    I poke Home Assistant using its own web interface... and the endless .yaml configuration files

    Once everything is said and done, I mostly use my Apple devices native "Home" app to actually control the devices. Home app talks to Home Assistant's HomeKit Bridge integration over wifi.

Parting thoughts

I'm not sure I can fully recommend my way of doing all of this, but the final word is that all my Ikea bulbs work right next to Xiaomi (Aqara) switches and motorized curtains. The Ikea plastic remote can be wired to do whatever. On top of this, my raspi is still just a docker host that can facilitate my other projects without being dedicated to just this. The total price of the project was... maybe 10€ with the CC2531 plus break out cables? Zigbee devices and raspi 3B+ not included.

The downside is that nothing "just works" initially. I feel like almost every bit of default configuration in these systems is somehow off and building the kind of smart home that I want is just going to be a lot of configuring. Oh well. At least I can "hey siri, close the curtains".

Pro tip: Ikea bulbs have this nice fade by default. I've seen many people say that they lose this fading when using Home Assistant etc. It's just a bad default in zigbee2mqtt that you can manually change in its configuration files to basically force every command like "turn lights on to 50% brightness" to include a "transition: 1 second" instruction. It just might throw you off that this kind of per-device configuration is done via zigbee2mqtt that actually talks to the device instead of Home Assistant that you talk to. Live and learn.

Sorry for the long read but oh man, do I wish I had read something like this a week ago to save a lot of cursing!
