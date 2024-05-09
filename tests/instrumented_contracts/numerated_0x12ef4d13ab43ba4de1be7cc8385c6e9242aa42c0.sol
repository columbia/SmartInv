1 /**
2  * Token staking contract developed for kauricrypto.com by Radek Ostrowski radek@startonchain.com
3  */
4 
5 pragma solidity ^0.5.13;
6 
7 /**
8  * @title ERC20
9  * @dev see https://github.com/ethereum/EIPs/issues/20
10  */
11 contract ERC20 {
12     uint256 public totalSupply;
13 
14     function balanceOf(address who) public view returns (uint256);
15     function transfer(address to, uint256 value) public returns (bool);
16     function allowance(address owner, address spender) public view returns (uint256);
17     function transferFrom(address from, address to, uint256 value) public returns (bool);
18     function approve(address spender, uint256 value) public returns (bool);
19 
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 }
23 
24 /**
25  * @title Ownable
26  * @dev The Ownable contract has an owner address, and provides basic authorization control
27  * functions, this simplifies the implementation of "user permissions".
28  */
29 contract Ownable {
30     address public owner;
31 
32     event OwnershipRenounced(address indexed previousOwner);
33     event OwnershipTransferred(
34         address indexed previousOwner,
35         address indexed newOwner
36     );
37 
38 
39     /**
40      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41      * account.
42      */
43     constructor() public {
44         owner = msg.sender;
45     }
46 
47     /**
48      * @dev Throws if called by any account other than the owner.
49      */
50     modifier onlyOwner() {
51         require(msg.sender == owner);
52         _;
53     }
54 
55     /**
56      * @dev Allows the current owner to relinquish control of the contract.
57      */
58     function renounceOwnership() public onlyOwner {
59         owner = address(0);
60         emit OwnershipRenounced(owner);
61     }
62 
63     /**
64      * @dev Allows the current owner to transfer control of the contract to a newOwner.
65      * @param _newOwner The address to transfer ownership to.
66      */
67     function transferOwnership(address _newOwner) public onlyOwner {
68         _transferOwnership(_newOwner);
69     }
70 
71     /**
72      * @dev Transfers control of the contract to a newOwner.
73      * @param _newOwner The address to transfer ownership to.
74      */
75     function _transferOwnership(address _newOwner) internal {
76         require(_newOwner != address(0));
77         owner = _newOwner;
78         emit OwnershipTransferred(owner, _newOwner);
79     }
80 }
81 
82 contract KauriStaking is Ownable {
83 
84     event TokensStaked(address stakedBy, address stakedFor, uint256 time, uint256 duration, uint256 amount);
85     event TokensUnstaked(address staker, uint256 time, uint256 amount, uint256 remaining);
86 
87     ERC20 public token;
88 
89     struct Staked {
90         uint256 time;
91         uint256 duration;
92         uint256 amount;
93     }
94 
95     mapping(address => Staked) private stakedTokens;
96 
97     constructor(ERC20 _token) public {
98         token = _token;
99     }
100 
101     function stakeTokens(uint256 _amount, uint256 _duration) public {
102         require(stakedTokens[msg.sender].amount == 0, "some tokens are already staked for this address");
103         token.transferFrom(msg.sender, address(this), _amount);
104         stakedTokens[msg.sender] = Staked(now, _duration, _amount);
105         emit TokensStaked(msg.sender, msg.sender, now, _duration, _amount);
106     }
107 
108     function stakeTokensFor(address _staker, uint256 _amount, uint256 _duration) public onlyOwner {
109         require(stakedTokens[_staker].amount == 0, "some tokens are already staked for this address");
110         token.transferFrom(msg.sender, address(this), _amount);
111         stakedTokens[_staker] = Staked(now, _duration, _amount);
112         emit TokensStaked(msg.sender, _staker, now, _duration, _amount);
113     }
114 
115     function withdrawTokens(uint256 _amount) public {
116         Staked memory staked = stakedTokens[msg.sender];
117         require(!isLocked(now, staked.time, staked.duration), "tokens are still locked");
118         require(staked.amount > 0, "no staked tokens to withdraw");
119 
120         //if trying to withdraw more than available, withdraw all
121         uint256 toWithdaw = _amount;
122         if(toWithdaw > staked.amount){
123             toWithdaw = staked.amount;
124         }
125 
126         token.transfer(msg.sender, toWithdaw);
127         if(staked.amount == toWithdaw){
128             //withdrawing all
129             stakedTokens[msg.sender] = Staked(0, 0, 0);
130         } else {
131             stakedTokens[msg.sender] = Staked(staked.time, staked.duration, staked.amount - toWithdaw);
132         }
133         emit TokensUnstaked(msg.sender, now, toWithdaw, staked.amount - toWithdaw);
134     }
135 
136     function isLocked(uint256 _now, uint256 _time, uint256 _duration) internal pure returns (bool) {
137         return _now >= _time + _duration ? false:true;
138     }
139 
140     function stakedDetails(address _staker) public view returns (uint256, uint256, uint256, bool) {
141         Staked memory staked = stakedTokens[_staker];
142         return (staked.time,
143         staked.duration,
144         staked.amount,
145         isLocked(now, staked.time, staked.duration));
146     }
147 }