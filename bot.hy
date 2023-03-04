#!/usr/bin/env hy

(import discord)
(import random [choice])

(setv intents (discord.Intents.default))
(setv intents.message_content True)
(setv client (discord.Client :intents intents))

;; TODO: Implement random (hint: use choice, list comprehensions, etc etc)
(defn roll [n x] ())  

(defn/a [client.event] on-ready []
  (print f"Logged in as {client.user}"))

(defn/a [client.event] on-message [message]
  (when (and
          (!= message.author client.user)
          (message.content.startswith "$hello"))
    (await (message.channel.send "hello!"))))

(when (= __name__ "__main__")
  (let [token (.read (open "token.txt"))]
    (client.run token)))