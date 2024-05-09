1 pragma solidity ^0.4.24;
2 
3 contract RHEM {
4     function balanceOf(address _owner) public view returns (uint256 balance);
5     function transfer(address _to, uint256 _value) public returns (bool success);
6 }
7 
8 contract Owner {
9     address public owner;
10 
11     /**
12      * @dev The Ownable constructor sets the original `owner`
13      * of the contract to the sender account.
14      */
15     constructor() public {
16         owner = msg.sender;
17     }
18 
19     /**
20      * @dev Throws if called by any account other than the current owner
21      */
22     modifier onlyOwner {
23         require(msg.sender == owner);
24         _;
25     }
26 }
27 
28 contract Locker is Owner {
29     RHEM rhem;
30     mapping(address => uint256) lockedBalances;
31     bool _isLocked = true;
32     uint256 totalLockedBalance;
33 
34     event Add(address to, uint256 value);
35     event Unlock();
36 
37     constructor(address _t) public {
38         rhem = RHEM(_t);
39     }
40 
41     /**
42      * @dev get Rhem Balance of Contract Address
43      */
44     function getContractRhemBalance() public view returns (uint256 balance) {
45         return rhem.balanceOf(address(this));
46     }
47 
48     /**
49      * @dev Add Address with Lock Rhem Token
50      */
51     function addLockAccount(address _addr, uint256 _value) public onlyOwner returns (bool success) {
52         require(_addr != address(0));
53         require(_value > 0);
54 
55         uint256 amount = lockedBalances[_addr];
56         amount += _value;
57         require(amount > 0);
58 
59         uint256 currentBalance = getContractRhemBalance();
60         totalLockedBalance += _value;
61         require(totalLockedBalance > 0);
62         require(totalLockedBalance <= currentBalance);
63 
64         lockedBalances[_addr] = amount;
65         emit Add(_addr, _value);
66 
67         return true;
68     }
69 
70     /**
71      * @dev Unlock
72      */
73     function unlock() public onlyOwner {
74         _isLocked = false;
75 
76         emit Unlock();
77     }
78 
79     /**
80      * @dev Check if locked
81      */
82     function isLocked() public view returns (bool) {
83         return _isLocked;
84     }
85 
86     /**
87      * @dev Get Lock Balance of Specific address
88      */
89     function lockedBalanceOf(address _addr) public view returns (uint256 lockedBalance) {
90         return lockedBalances[_addr];
91     }
92 
93     /**
94      * @dev Release Lock Rhem Token of the sender
95      */
96     function release() public returns(bool success) {
97         require(!_isLocked);
98         require(lockedBalances[msg.sender] > 0);
99 
100         rhem.transfer(msg.sender, lockedBalances[msg.sender]);
101         delete lockedBalances[msg.sender];
102 
103         return true;
104     }
105 }