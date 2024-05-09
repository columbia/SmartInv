1 pragma solidity ^0.4.17;
2 
3 contract LatiumX {
4     string public constant name = "LatiumX";
5     string public constant symbol = "LATX";
6     uint8 public constant decimals = 8;
7     uint256 public constant totalSupply =
8         300000000 * 10 ** uint256(decimals);
9 
10     // owner of this contract
11     address public owner;
12 
13     // balances for each account
14     mapping (address => uint256) public balanceOf;
15 
16     // triggered when tokens are transferred
17     event Transfer(address indexed _from, address indexed _to, uint _value);
18 
19     // constructor
20     function LatiumX() {
21         owner = msg.sender;
22         balanceOf[owner] = totalSupply;
23     }
24 
25     // transfer the balance from sender's account to another one
26     function transfer(address _to, uint256 _value) {
27         // prevent transfer to 0x0 address
28         require(_to != 0x0);
29         // sender and recipient should be different
30         require(msg.sender != _to);
31         // check if the sender has enough coins
32         require(_value > 0 && balanceOf[msg.sender] >= _value);
33         // check for overflows
34         require(balanceOf[_to] + _value > balanceOf[_to]);
35         // subtract coins from sender's account
36         balanceOf[msg.sender] -= _value;
37         // add coins to recipient's account
38         balanceOf[_to] += _value;
39         // notify listeners about this transfer
40         Transfer(msg.sender, _to, _value);
41     }
42 }
43 
44 contract LatiumLocker {
45     address private constant _latiumAddress = 0x2f85E502a988AF76f7ee6D83b7db8d6c0A823bf9;
46     LatiumX private constant _latium = LatiumX(_latiumAddress);
47 
48     // total amount of Latium tokens that can be locked with this contract
49     uint256 private _lockLimit = 0;
50 
51     // variables for release tiers and iteration thru them
52     uint32[] private _timestamps = [
53         1517400000 // 2018-01-31 12:00:00 UTC
54         , 1525089600 // 2018-04-30 12:00:00 UTC
55         , 1533038400 // 2018-07-31 12:00:00 UTC
56         , 1540987200 // 2018-10-31 12:00:00 UTC
57         
58     ];
59     uint32[] private _tokensToRelease = [ // without decimals
60         15000000
61         , 15000000
62         , 15000000
63         , 15000000
64        
65     ];
66     mapping (uint32 => uint256) private _releaseTiers;
67 
68     // owner of this contract
69     address public owner;
70 
71     // constructor
72     function LatiumLocker() {
73         owner = msg.sender;
74         // initialize release tiers with pairs:
75         // "UNIX timestamp" => "amount of tokens to release" (with decimals)
76         for (uint8 i = 0; i < _timestamps.length; i++) {
77             _releaseTiers[_timestamps[i]] =
78                 _tokensToRelease[i] * 10 ** uint256(_latium.decimals());
79             _lockLimit += _releaseTiers[_timestamps[i]];
80         }
81     }
82 
83     // function to get current Latium balance (with decimals)
84     // of this contract
85     function latiumBalance() constant returns (uint256 balance) {
86         return _latium.balanceOf(address(this));
87     }
88 
89     // function to get total amount of Latium tokens (with decimals)
90     // that can be locked with this contract
91     function lockLimit() constant returns (uint256 limit) {
92         return _lockLimit;
93     }
94 
95     // function to get amount of Latium tokens (with decimals)
96     // that are locked at this moment
97     function lockedTokens() constant returns (uint256 locked) {
98         locked = 0;
99         uint256 unlocked = 0;
100         for (uint8 i = 0; i < _timestamps.length; i++) {
101             if (now >= _timestamps[i]) {
102                 unlocked += _releaseTiers[_timestamps[i]];
103             } else {
104                 locked += _releaseTiers[_timestamps[i]];
105             }
106         }
107         uint256 balance = latiumBalance();
108         if (unlocked > balance) {
109             locked = 0;
110         } else {
111             balance -= unlocked;
112             if (balance < locked) {
113                 locked = balance;
114             }
115         }
116     }
117 
118     // function to get amount of Latium tokens (with decimals)
119     // that can be withdrawn at this moment
120     function canBeWithdrawn() constant returns (uint256 unlockedTokens, uint256 excessTokens) {
121         unlockedTokens = 0;
122         excessTokens = 0;
123         uint256 tiersBalance = 0;
124         for (uint8 i = 0; i < _timestamps.length; i++) {
125             tiersBalance += _releaseTiers[_timestamps[i]];
126             if (now >= _timestamps[i]) {
127                 unlockedTokens += _releaseTiers[_timestamps[i]];
128             }
129         }
130         uint256 balance = latiumBalance();
131         if (unlockedTokens > balance) {
132             // actual Latium balance of this contract is smaller
133             // than can be released at this moment
134             unlockedTokens = balance;
135         } else if (balance > tiersBalance) {
136             // if actual Latium balance of this contract is greater
137             // than can be locked, all excess tokens can be withdrawn
138             // at any time
139             excessTokens = (balance - tiersBalance);
140         }
141     }
142 
143     // functions with this modifier can only be executed by the owner
144     modifier onlyOwner() {
145         require(msg.sender == owner);
146         _;
147     }
148 
149     // function to withdraw Latium tokens that are unlocked at this moment
150     function withdraw(uint256 _amount) onlyOwner {
151         var (unlockedTokens, excessTokens) = canBeWithdrawn();
152         uint256 totalAmount = unlockedTokens + excessTokens;
153         require(totalAmount > 0);
154         if (_amount == 0) {
155             // withdraw all available tokens
156             _amount = totalAmount;
157         }
158         require(totalAmount >= _amount);
159         uint256 unlockedToWithdraw =
160             _amount > unlockedTokens ?
161                 unlockedTokens :
162                 _amount;
163         if (unlockedToWithdraw > 0) {
164             // update tiers data
165             uint8 i = 0;
166             while (unlockedToWithdraw > 0 && i < _timestamps.length) {
167                 if (now >= _timestamps[i]) {
168                     uint256 amountToReduce =
169                         unlockedToWithdraw > _releaseTiers[_timestamps[i]] ?
170                             _releaseTiers[_timestamps[i]] :
171                             unlockedToWithdraw;
172                     _releaseTiers[_timestamps[i]] -= amountToReduce;
173                     unlockedToWithdraw -= amountToReduce;
174                 }
175                 i++;
176             }
177         }
178         // transfer tokens to owner's account
179         _latium.transfer(msg.sender, _amount);
180     }
181 }