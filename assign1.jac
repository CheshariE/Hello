"""A Holiday Guessing Game (Kenya, 2026)"""

import random;
import from byllm.llm { Model }

# glob llm = Model(model_name="gpt-4o",verbose=False);
glob llm = Model(model_name="gemini/gemini-2.0-flash", verbose=False);

"""Provide a fun hint if guess is incorrect"""
def give_hint(guess: int, correct_number: int) -> str by llm();
   

walker GuessGame {
    has guess: int;

    can start with `root entry;
    can process_guess with turn entry;
}

node turn {
    # Fixed to match Kenya's estimated holiday count in 2026
    has correct_number: int = 12;
}

impl GuessGame.start {
    if not [root --> (`?turn)] {
        next = root ++> turn(12);
    } else {
        next = [root --> (`?turn)];
    }
    visit next;
}

impl GuessGame.process_guess {
    if [-->] {
        visit [-->];
    } else {
        if self.guess < here.correct_number {
            print(give_hint(self.guess, here.correct_number));
            here ++> turn(here.correct_number);
        } elif self.guess > here.correct_number {
            print(give_hint(self.guess, here.correct_number));
            here ++> turn(here.correct_number);
        } else {
            print("🎉 Correct! Kenya has 12 public holidays in 2026.");
            disengage;
        }
    }
}

with entry:__main__ {
    root spawn GuessGame(8);    # Too low
    root spawn GuessGame(14);   # Too high
    root spawn GuessGame(12);   # Correct
    root spawn GuessGame(10);   # Close but wrong
}
