1 pragma solidity ^0.4.2;
2 
3 contract OwnedI {
4     event LogOwnerChanged(address indexed previousOwner, address indexed newOwner);
5 
6     function getOwner()
7         constant
8         returns (address);
9 
10     function setOwner(address newOwner)
11         returns (bool success); 
12 }
13 
14 contract Owned is OwnedI {
15     /**
16      * @dev Made private to protect against child contract setting it to 0 by mistake.
17      */
18     address private owner;
19 
20     function Owned() {
21         owner = msg.sender;
22     }
23 
24     modifier fromOwner {
25         if (msg.sender != owner) {
26             throw;
27         }
28         _;
29     }
30 
31     function getOwner()
32         constant
33         returns (address) {
34         return owner;
35     }
36 
37     function setOwner(address newOwner)
38         fromOwner 
39         returns (bool success) {
40         if (newOwner == 0) {
41             throw;
42         }
43         if (owner != newOwner) {
44             LogOwnerChanged(owner, newOwner);
45             owner = newOwner;
46         }
47         success = true;
48     }
49 }
50 
51 contract BalanceFixable is OwnedI {
52     function fixBalance() 
53         returns (bool success) {
54         if (!getOwner().send(this.balance)) {
55             throw;
56         }
57         return true;
58     }
59 }
60 
61 contract Migrations is Owned, BalanceFixable {
62     uint public last_completed_migration;
63     address public allowedAccount;
64 
65     function Migrations() {
66         if(msg.value > 0) throw;
67     }
68 
69     function setCompleted(uint completed) {
70         if (msg.sender != getOwner()
71             && msg.sender != allowedAccount) {
72             throw;
73         }
74         last_completed_migration = completed;
75     }
76 
77     function setAllowedAccount(address _allowedAccount) fromOwner {
78         allowedAccount = _allowedAccount;
79     }
80 
81     function upgrade(address new_address) fromOwner {
82         Migrations upgraded = Migrations(new_address);
83         upgraded.setCompleted(last_completed_migration);
84     }
85 }