1 /*
2  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
3  */
4 pragma solidity ^0.4.17;
5 
6 contract Ownable {
7     address public Owner;
8 
9     modifier onlyOwner {
10         require(msg.sender == Owner);
11         _;
12     }
13     
14     function kill() public onlyOwner {
15         require(this.balance == 0);
16         selfdestruct(Owner);
17     }
18 }
19 
20 contract Lockable is Ownable {
21     bool public Locked;
22     
23     modifier isUnlocked {
24         require(!Locked);
25         _;
26     }
27     function Lockable() { Locked = false; }
28     function lock() public onlyOwner { Locked = true; }
29     function unlock() public onlyOwner { Locked = false; }
30 }
31 
32 contract Transferable is Lockable {
33     address public PendingOwner;
34     
35     modifier onlyPendingOwner {
36         require(msg.sender == PendingOwner);
37         _;
38     }
39 
40     event OwnershipTransferPending(address indexed Owner, address indexed PendingOwner);
41     event AcceptedOwnership(address indexed NewOwner);
42 
43     function transferOwnership(address _new) public onlyOwner {
44         PendingOwner = _new;
45         OwnershipTransferPending(Owner, PendingOwner);
46     }
47 
48     function acceptOwnership() public onlyPendingOwner {
49         Owner = msg.sender;
50         PendingOwner = address(0x0);
51         AcceptedOwnership(Owner);
52     }
53 }
54 
55 contract Vault is Transferable {
56     
57     event Initialized(address owner);
58     event LockDate(uint oldDate, uint newDate);
59     event Deposit(address indexed depositor, uint amount);
60     event Withdrawal(address indexed withdrawer, uint amount);
61     
62     mapping (address => uint) public deposits;
63     uint public lockDate;
64 
65     function init() public payable isUnlocked {
66         Owner = msg.sender;
67         lockDate = 0;
68         Initialized(msg.sender);
69     }
70     
71     function SetLockDate(uint newDate) public payable onlyOwner {
72         LockDate(lockDate, newDate);
73         lockDate = newDate;
74     }
75     
76     function() public payable { deposit(); }
77 
78     function deposit() public payable {
79         if (msg.value >= 0.1 ether) {
80             deposits[msg.sender] += msg.value;
81             Deposit(msg.sender, msg.value);
82         }
83     }
84 
85     function withdraw(uint amount) public payable onlyOwner {
86         if (lockDate > 0 && now >= lockDate) {
87             uint max = deposits[msg.sender];
88             if (amount <= max && max > 0) {
89                 msg.sender.transfer(amount);
90                 Withdrawal(msg.sender, amount);
91             }
92         }
93     }
94 }