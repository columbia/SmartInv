1 pragma solidity ^0.4.13;
2 
3 interface EtherShare {
4     function NewShare(string nickname, bool AllowUpdated, string content);
5 }
6 
7 //Enable user to share information for free (using donation) on Ethereum
8 contract EtherShareDonation {
9 
10     EtherShare ES = EtherShare(0xc86bdf9661c62646194ef29b1b8f5fe226e8c97e);
11     
12     struct oneDonation {
13         address donator;
14         string nickname;
15         uint amount;
16     }
17     oneDonation[] public donations;
18 
19     function Donate(string nickname) payable public {
20         donations.push(oneDonation(msg.sender, nickname, msg.value));	//record the donation
21     }
22 
23     function FreeShare(string nickname, string content) public {
24         uint startGasLeft = gasleft();
25         ES.NewShare(nickname, false, content); 
26         uint endGasLeft = gasleft();
27         msg.sender.send( tx.gasprice*(startGasLeft-endGasLeft+35000) );	//return the fee of NewShare, 35000 gas for other transaction fee.
28     }
29 
30     //TODO: SenderRecord(), FreeReply(), FreeUpdate()
31 }