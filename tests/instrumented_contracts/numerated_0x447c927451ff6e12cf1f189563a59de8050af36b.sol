1 pragma solidity ^0.4.18;
2 
3 // Splitter is an Ether payment splitter contract between an owner and a payee
4 // account. Both payee and owner gets funded immediately upon receipt of payment, whilst
5 // the owner can withdraw accumulated funds upon request if something goes wrong
6 
7 
8 //THIS CONTRACT DEPLOYMENT USES 362992 GAS
9 
10 
11 contract Splitter {
12     address public owner;   // Owner of the contract, will get `percent` of all transferred funds
13     address public payee = 0xAc71D3aC1fd7a56f731fb28E5F582cC6042cB61B;   // Payee of the contract, will get 100 - `percent` of all transferred funds
14     uint    public percent = 10; // Percent of the funds to transfer to the payee (range: 1 - 99)
15     
16     // Splitter creates a fund splitter, forwarding 'percent' of any received funds
17     // to the 'owner' and 100 percent for the payee.
18     function Splitter() public {
19         owner   = msg.sender;
20     }
21     
22     // Withdraw pulls the entire (if any) balance of the contract to the owner's
23     // account.
24     function Withdraw() external {
25         require(msg.sender == owner);
26         owner.transfer(this.balance);
27     }
28     
29     // Default function to accept Ether transfers and forward some percentage of it
30     // to the owner's account and the payee
31     function() external payable {
32         owner.transfer(msg.value * percent / 100);
33         payee.transfer(msg.value * (100 - percent) / 100);
34     }
35 }