1 pragma solidity ^0.4.19;
2 
3 
4 contract GKInterface {
5 
6  function enter(bytes32 _passcode, bytes8 _gateKey) public returns (bool);
7   
8 }
9 
10 contract theProxy  {
11   // This contract collects addresses of the initial members of theCyber. In
12   // order to register, the entrant must first provide a passphrase that will
13   // hash to a sequence known to the gatekeeper. They must also find a way to
14   // get around a few barriers to entry before they can successfully register.
15   // Once 250 addresses have been submitted, the assignAll method may be called,
16   // which (assuming theCyberGatekeeper is itself a member of theCyber), will
17   // assign 250 new members, each owned by one of the submitted addresses.
18 
19   // The gatekeeper will interact with theCyber contract at the given address.
20   address private constant THECYBERGATEKEEPER_ = 0x44919b8026f38D70437A8eB3BE47B06aB1c3E4Bf;
21 
22   function theProxy() public {}
23 
24   
25 
26   function enter(bytes32 _passcode, bytes8 _gateKey) public returns (bool) {
27     
28     GKInterface gk = GKInterface(THECYBERGATEKEEPER_);
29     return gk.enter(_passcode, _gateKey);
30 
31   }
32 
33 }