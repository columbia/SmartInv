1 pragma solidity ^0.4.21;
2 
3 // Donate all your ethers to 0x7Ec 
4 // Made by EtherGuy (etherguy@mail.com)
5 // CryptoGaming Discord https://discord.gg/gjrHXFr
6 // UI @ htpts://0x7.surge.sh
7 
8 contract InteractiveDonation{
9     address constant public Donated = 0x7Ec915B8d3FFee3deaAe5Aa90DeF8Ad826d2e110;
10     
11     event Quote(address Sent, string Text, uint256 AmtDonate);
12 
13     string public DonatedBanner = "";
14     
15 
16     
17     function Donate(string quote) public payable {
18         require(msg.sender != Donated); // GTFO dont donate to yourself
19         
20         emit Quote(msg.sender, quote, msg.value);
21     }
22     
23     function Withdraw() public {
24         if (msg.sender != Donated){
25             emit Quote(msg.sender, "OMG CHEATER ATTEMPTING TO WITHDRAW", 0);
26             return;
27         }
28         address contr = this;
29         msg.sender.transfer(contr.balance);
30     }   
31     
32     function DonatorInteract(string text) public {
33         require(msg.sender == Donated);
34         emit Quote(msg.sender, text, 0);
35     }
36     
37     function DonatorSetBanner(string img) public {
38         require(msg.sender == Donated);
39         DonatedBanner = img;
40     }
41     
42     function() public payable{
43         require(msg.sender != Donated); // Nice cheat but no donating to yourself 
44     }
45     
46 }