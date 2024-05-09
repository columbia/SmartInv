1 contract AlarmClockTipFaucet {
2 // Alarm Clock 0.8 is on its way, adding time-based scheduling to Ethereum
3 
4 // This is a contract for tipping the dev for the work leading up to this 0.8 release
5 
6 // The TipFaucet is open for 10 days, after which the dev can withdraw a clump-sum
7 
8 address piperMerriam;
9 uint timeToPayout;
10 
11 
12 function AlarmClockTipFaucet() {
13     piperMerriam = 0xd3cda913deb6f67967b99d67acdfa1712c293601;
14     timeToPayout = now + 10 days;
15 }
16 
17 modifier isPiper { 
18 if (msg.sender != piperMerriam) throw;
19 _
20 }
21 
22 modifier isOpen {
23 if(block.timestamp > timeToPayout) throw;
24 _
25 }
26 
27 modifier canWithdraw {
28 if(block.timestamp < timeToPayout) throw;
29 _
30 }
31 
32 function() isOpen {
33 }
34 
35 function withdraw() isPiper canWithdraw {
36     msg.sender.send(this.balance);
37 }
38 
39 }