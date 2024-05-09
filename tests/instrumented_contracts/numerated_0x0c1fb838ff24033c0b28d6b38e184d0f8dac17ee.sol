1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function sub(uint a, uint b) internal pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function mul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function div(uint a, uint b) internal pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 contract ERC20Token {
23     using SafeMath for uint;
24 
25     string public constant symbol = "EBT";
26     string public constant name = "EtherBet Token";
27     uint8 public constant decimals = 9;
28     uint public totalSupply = 0;
29     mapping(address => uint) balances;
30     mapping(address => mapping(address => uint)) allowed;
31 
32     function balanceOf(address tokenOwner) public constant returns (uint) {
33         return balances[tokenOwner];
34     }
35 
36     function transfer(address to, uint tokens) public returns (bool) {
37         balances[msg.sender] = balances[msg.sender].sub(tokens);
38         balances[to] = balances[to].add(tokens);
39         Transfer(msg.sender, to, tokens);
40         return true;
41     }
42 
43     function approve(address spender, uint tokens) public returns (bool) {
44         allowed[msg.sender][spender] = tokens;
45         Approval(msg.sender, spender, tokens);
46         return true;
47     }
48 
49     function transferFrom(address from, address to, uint tokens) public returns (bool) {
50         balances[from] = balances[from].sub(tokens);
51         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
52         balances[to] = balances[to].add(tokens);
53         Transfer(from, to, tokens);
54         return true;
55     }
56 
57     event Transfer(address indexed from, address indexed to, uint tokens);
58     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
59 }
60 
61 contract Owned {
62     address public owner;
63     address public newOwner;
64 
65     event OwnershipTransferred(address indexed _from, address indexed _to);
66 
67     function Owned() public {
68         owner = msg.sender;
69     }
70 
71     modifier onlyOwner {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     function transferOwnership(address _newOwner) public onlyOwner {
77         newOwner = _newOwner;
78     }
79 
80     function acceptOwnership() public {
81         require(msg.sender == newOwner);
82         OwnershipTransferred(owner, newOwner);
83         owner = newOwner;
84         newOwner = address(0);
85     }
86 }
87 
88 contract ICO is ERC20Token, Owned {
89     uint private constant icoPart = 40;
90     uint private constant priceStart =  300000000000000 wei;
91     uint private constant priceEnd   = 1000000000000000 wei;
92     uint private icoBegin;
93     uint public icoEnd;
94 
95     function ICO(uint duration) public {
96         icoBegin = now;
97         icoEnd = icoBegin.add(duration);
98     }
99 
100     function icoTokenPrice() public constant returns (uint) {
101         require(now <= icoEnd);
102         return priceStart.add(priceEnd.sub(priceStart).mul(now.sub(icoBegin)).div(icoEnd.sub(icoBegin)));
103     }
104 
105     function () public payable {
106         require(now <= icoEnd && msg.value > 0);
107         uint coins = msg.value.mul(uint(10)**decimals).div(icoTokenPrice());
108         totalSupply = totalSupply.add(coins.mul(100).div(icoPart));
109         balances[msg.sender] = balances[msg.sender].add(coins);
110         Transfer(address(0), msg.sender, coins);
111         coins = coins.mul(100 - icoPart).div(icoPart);
112         balances[owner] = balances[owner].add(coins);
113         Transfer(address(0), owner, coins);
114     }
115 }
116 
117 contract EtherBetToken is ICO {
118     enum Winner {
119         First, Draw, Second, Cancelled, None
120     }
121 
122     struct BetEvent {
123         uint from;
124         uint until;
125         string category;
126         string tournament;
127         string player1;
128         string player2;
129         Winner winner;
130     }
131 
132     struct Bet {
133         address user;
134         Winner winner;
135         uint amount;
136     }
137 
138     uint public reserved = 0;
139     BetEvent[] public betEvents;
140     mapping(uint => Bet[]) public bets;
141 
142     function EtherBetToken() public ICO(60*60*24*30) {
143     }
144 
145     function availableBalance() public constant returns (uint) {
146         return this.balance.sub(reserved);
147     }
148 
149     function withdraw(uint amount) public {
150         var toTransfer = amount.mul(availableBalance()).div(totalSupply);
151         balances[msg.sender] = balances[msg.sender].sub(amount);
152         totalSupply = totalSupply.sub(amount);
153         msg.sender.transfer(toTransfer);
154     }
155 
156     function betOpen(uint duration, string category, string tournament, string player1, string player2) public onlyOwner {
157         betEvents.push(BetEvent(now, now.add(duration), category, tournament, player1, player2, Winner.None));
158     }
159 
160     function getEventBanks(uint eventId) public constant returns (uint[3] banks) {
161         require(eventId < betEvents.length);
162         for (uint i = 0; i < bets[eventId].length; i++) {
163             Bet storage bet = bets[eventId][i];
164             banks[uint(bet.winner)] = banks[uint(bet.winner)].add(bet.amount);
165         }
166     }
167 
168     function betFinalize(uint eventId, Winner winner) public onlyOwner {
169         BetEvent storage betEvent = betEvents[eventId];
170         require(winner < Winner.None && betEvent.winner == Winner.None && eventId < betEvents.length && now > betEvent.until);
171         betEvent.winner = winner;
172         uint[3] memory banks = getEventBanks(eventId);
173         uint loserBank = banks[0].add(banks[1]).add(banks[2]).sub(banks[uint(winner)]).mul(99).div(100);
174         uint winnerBank = banks[uint(winner)];
175         reserved = reserved.sub(banks[0]).sub(banks[1]).sub(banks[2]);
176 
177         for (uint i = 0; i < bets[eventId].length; i++) {
178             Bet storage bet = bets[eventId][i];
179             if (winner == Winner.Cancelled) {
180                 bet.user.transfer(bet.amount);
181                 continue;
182             }
183             if (bet.winner == winner) {
184                 bet.user.transfer(bet.amount.add(bet.amount.mul(loserBank).div(winnerBank)));
185             }
186         }
187     }
188 
189     function betMake(uint eventId, Winner winner) public payable {
190         require(winner != Winner.Cancelled && winner < Winner.None && msg.value > 0 && eventId < betEvents.length && now <= betEvents[eventId].until);
191         bets[eventId].push(Bet(msg.sender, winner, msg.value));
192         reserved = reserved.add(msg.value);
193     }
194 
195     function getEvents(uint from, string category, uint mode) public constant returns (uint cnt, uint[20] res) {
196         require(mode < 3 && from <= betEvents.length);
197         bytes32 categoryHash = keccak256(category);
198         cnt = 0;
199         for (int i = int(from == 0 ? betEvents.length : from)-1; i >= 0; i--) {
200             uint index = uint(i);
201             if ((mode == 0 ? betEvents[index].until >= now : (mode == 1 ? betEvents[index].until < now && betEvents[index].winner == Winner.None : (mode == 2 ? betEvents[index].winner != Winner.None : false))) && (keccak256(betEvents[index].category) == categoryHash)) {
202                 res[cnt++] = index;
203                 if (cnt == res.length) break;
204             }
205         }
206     }
207 
208     function getEventsCount() public constant returns (uint) {
209         return betEvents.length;
210     }
211 }