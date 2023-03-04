#!/usr/bin/env hy

(import discord)
(import random [choice])

(setv intents (discord.Intents.default))
(setv intents.message_content True)
(setv client (discord.Client :intents intents))

;; TODO: Implement random (hint: use choice, list comprehensions, etc etc)
; 1d20 => rolls a 20
; 2d6 => rolls 2 6's and adds up the result
(defn roll-die [n]
  (assert (> n 1))
  (assert (= int (type n)))
  (choice (range 1 (+ n 1))))

(defn roll [x n]
  (assert (> n 1))
  (assert (> x 0))
  (lfor _ (range x) (roll-die n)))

(defn/a [client.event] on-ready []
  (print f"Logged in as {client.user}"))

(defn/a [client.event] on-message [message]
  "Do this on every message"
  (try
    (when (!= message.author client.user)
      (let [msg message.content
            [? dice] (.split msg)
            [x n] (list (map int (dice.split "d")))
            rolls (roll x n)
            sum (sum rolls)
            rolls-string (if (= x 1) (. rolls [0]) (+ (.join " + " (map str rolls)) f" = {sum}"))]
            (await (message.reply f"🎲 → {rolls-string}"))))
    (except [Exception]
      None)))

(when (= __name__ "__main__")
  (let [token (.read (open "token.txt"))]
    (client.run token)))