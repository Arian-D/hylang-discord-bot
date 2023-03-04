#!/usr/bin/env hy

(import discord)
(import random [choice])

(setv intents (discord.Intents.default))
(setv intents.message_content True)
(setv client (discord.Client :intents intents))

(defn roll-die [n]
  "Generate a random positive integer between 1 and n (inclusive)"
  (choice (range 1 (+ n 1))))

(defn roll [msg]
  "Generate an output based on message content"
  (let [[_ dice] (.split msg)
        [x n] (list (map int (dice.split "d")))
        rolls (lfor _ (range x) (roll-die n))
        sum (sum rolls)
        rolls-string (if (= x 1) (. rolls [0]) (+ (.join " + " (map str rolls)) f" = {sum}"))]
    f"🎲 → {rolls-string}"))

(defn toss []
  "Generate random coin toss output"
  (str (choice '(head tail))))

(defn/a [client.event] on-ready []
  (print f"Logged in as {client.user}"))

(defn/a [client.event] on-message [message]
  "Do this on every message"
  (try
    (when (!= message.author client.user)
      (when (message.content.startswith "roll ")
        (await (message.reply (roll message.content))))
      (when (in message.content #{"toss coin" "toss a coin"})
        (await (message.reply f"🪙 → {(toss)}"))))
    (except [Exception]
      None)))


(when (= __name__ "__main__")
  (let [token (.read (open "token.txt"))]
    (client.run token)))