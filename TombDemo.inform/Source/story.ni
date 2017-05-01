"TombDemo" by Cole Erickson

Include Vorple by Juhana Leinonen.
Include Vorple Command Prompt Control by Juhana Leinonen.

Chapter 0 - Vorpal and updating our hud

[This is of course all important.  I could provide this myself (and plan to at some point)
but for now it's just more convenient to use their pre-built stuff.]
Release along with the "Vorple" interpreter.

[This file has a few functions, most of which we will call in the following few rules]
Release along with Javascript "text.js".

[A couple of useful functions that we'll make use of]
To update the list of visible items:
	let itemList be "";
	repeat with visibleItem running through visible objects:
		let itemList be "[itemList]%[printed name of visibleItem]";
	replace the text "[apostrophe]" in itemList with "\[apostrophe]";
	execute Javascript command "updateVisibleItems([apostrophe][itemList][apostrophe]);".

[Some runtime hooks to update our UI]
When play begins:
	If Vorple is supported:
		execute Javascript command "tombInit();";
		update the list of visible items.

Every turn when Vorple is supported:
	update the list of visible items.

Chapter 1 - Actual game stuff

The Clearing is a room.  "You stand outside a stone portal that seems to lead into the hillside.  The doorway to this tunnel is sealed with two large stone doors, chained together at the center."

The tree is a thing in the clearing.  The printed name of the tree is "the lover[apostrophe]s tree".

The flower is a thing in the clearing with printed name "[quotation mark]rosie[quotation mark] the rose bush".

The Cave is a room.  The cave is north of the clearing.
