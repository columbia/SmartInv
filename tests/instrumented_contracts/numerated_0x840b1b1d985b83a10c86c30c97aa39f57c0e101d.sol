1 pragma solidity ^0.4.18;
2 
3 contract ERC20Interface {
4     uint256 public totalSupply;
5     function balanceOf(address who) public constant returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract Yum is ERC20Interface {
11     uint256 public constant INITIAL_SUPPLY = 3000000 * (10 ** uint256(decimals));
12     string public constant symbol = "YUM";
13     string public constant name = "YUM Token";
14     uint8 public constant decimals = 18;
15     uint256 public constant totalSupply = INITIAL_SUPPLY;
16     
17     // Owner is the address controlled by FilletX.
18     address constant owner = 0x045da370c3c0A1A55501F3B78Becc78a084CC488;
19 
20     // Account represents a user account.
21     struct Account {
22         // Balance is the user balance. 
23         uint256 balance;
24         // Addr is the address of the account.
25         address addr;
26         // Enabled is true if the user is able to transfer funds.
27         bool enabled;
28     }
29 
30     // Accounts holds user accounts.
31     mapping(address => Account) accounts;
32     
33     // Constructor.
34     function Yum() public {
35         accounts[owner] = Account({
36           addr: owner,
37           balance: INITIAL_SUPPLY,
38           enabled: true
39         });
40     }
41 
42     // Get balace of an account.
43     function balanceOf(address _owner) public constant returns (uint balance) {
44         return accounts[_owner].balance;
45     }
46     
47     // Set enabled status of the account.
48     function setEnabled(address _addr, bool _enabled) public {
49         assert(msg.sender == owner);
50         if (accounts[_addr].enabled != _enabled) {
51             accounts[_addr].enabled = _enabled;
52         }
53     }
54     
55     // Transfer funds.
56     function transfer(address _to, uint256 _amount) public returns (bool) {
57         require(_to != address(0));
58         require(_amount <= accounts[msg.sender].balance);
59         // Enable the receiver if the sender is the exchange.
60         if (msg.sender == owner && !accounts[_to].enabled) {
61             accounts[_to].enabled = true;
62         }
63         if (
64             // Check that the sender's account is enabled.
65             accounts[msg.sender].enabled
66             // Check that the receiver's account is enabled.
67             && accounts[_to].enabled
68             // Check that the sender has sufficient balance.
69             && accounts[msg.sender].balance >= _amount
70             // Check that the amount is valid.
71             && _amount > 0
72             // Check for overflow.
73             && accounts[_to].balance + _amount > accounts[_to].balance) {
74                 // Credit the sender.
75                 accounts[msg.sender].balance -= _amount;
76                 // Debit the receiver.
77                 accounts[_to].balance += _amount;
78                 Transfer(msg.sender, _to, _amount);
79                 return true;
80         }
81         return false;
82     }
83 }