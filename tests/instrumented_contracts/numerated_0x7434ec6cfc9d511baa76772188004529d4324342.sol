1 pragma solidity ^0.4.24;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract StubeeEduCoin {
6     // Public variables of the token
7     // 토큰의 공용 변수
8     string public name;
9     string public symbol;
10     uint8 public decimals = 18;
11     // 18 decimals is the strongly suggested default, avoid changing it
12     // 18개의 소수점이 강하게 제안된 기본값입니다. 변경하지 마십시오.
13 
14     uint256 public totalSupply;
15 
16     // This creates an array with all balances
17     // 이렇게 하면 모든 밸런스를 가진 배열이 만들어집니다.
18     mapping (address => uint256) public balanceOf;
19     mapping (address => mapping (address => uint256)) public allowance;
20 
21     // This generates a public event on the blockchain that will notify clients
22     // 이렇게 하면 블록체인에 대해 고객에게 알릴 공개 이벤트가 생성됩니다.
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     
25     // This generates a public event on the blockchain that will notify clients
26     // 이렇게 하면 블록체인에 대해 고객에게 알릴 공개 이벤트가 생성됩니다.
27     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
28 
29     // This notifies clients about the amount burnt
30     // 이는 고객에게 연소된 양을 알려줍니다.
31     event Burn(address indexed from, uint256 value);
32 
33     /**
34      * Constructor function
35      *
36      * Initializes contract with initial supply tokens to the creator of the contract
37      * 계약 작성자에게 초기 공급 토큰과 계약을 초기화합니다.
38      */
39     constructor (
40         address fromAdd,
41         uint256 initialSupply,
42         string tokenName,
43         string tokenSymbol
44     ) public {
45 
46         // Update total supply with the decimal amount
47         // 총 공급량을 십진수로 업데이트합니다.
48         totalSupply = initialSupply * 10 ** uint256(decimals);  
49         
50         // Give the creator all initial tokens
51         // 작성자에게 모든 초기 토큰 제공
52         balanceOf[fromAdd] = totalSupply;                
53 
54         // Set the name for display purposes
55         // 표시에 사용할 이름 설정
56         name = tokenName;        
57 
58         // Set the symbol for display purposes
59         // 표시 용도의 기호 설정                           
60         symbol = tokenSymbol;                               
61     }
62 
63     /**
64      * Internal transfer, only can be called by this contract
65      * 내부 이전, 이 계약에서만 호출할 수 있습니다.
66      */
67     function _transfer(address _from, address _to, uint _value) internal {
68 
69         // Prevent transfer to 0x0 address. Use burn() instead
70         // 0x0 주소로 전송하지 마십시오. 대신 굽기()를 사용합니다.
71         require(_to != 0x0);
72 
73 
74         // Check if the sender has enough
75         // 발신인이 충분한지 확인
76         require(balanceOf[_from] >= _value);
77 
78 
79         // Check for overflows
80         // 오버플로우 확인
81         require(balanceOf[_to] + _value >= balanceOf[_to]);
82 
83 
84         // Save this for an assertion in the future
85         // 향후 주장을 위해 저장
86         uint previousBalances = balanceOf[_from] + balanceOf[_to];
87 
88 
89         // Subtract from the sender
90         // 발신자에서 빼기
91         balanceOf[_from] -= _value;
92 
93 
94         // Add the same to the recipient
95         // 수신자에게 동일한 항목 추가
96         balanceOf[_to] += _value;
97         emit Transfer(_from, _to, _value);
98 
99 
100         // Asserts are used to use static analysis to find bugs in your code. They should never fail
101         // 명령어는 정적 분석을 사용하여 코드의 버그를 찾는 데 사용됩니다. 그들은 절대 실패해서는 안된다.
102         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
103     }
104 
105     /**
106      * Transfer tokens
107      *
108      * Send `_value` tokens to `_to` from your account
109      * 당신의 계정에서 '_value' 토큰을 '_to'로 보냅니다.
110      *
111      * @param _to The address of the recipient(받는 사람의 주소)
112      * @param _value the amount to send (송금액)
113      */
114     function transfer(address _to, uint256 _value) public returns (bool success) {
115         _transfer(msg.sender, _to, _value);
116         return true;
117     }
118 
119     /**
120      * Transfer tokens from other address
121      *
122      * Send `_value` tokens to `_to` on behalf of `_from`
123      * '_from' 대신 `_value`토큰을 `_to`로 보냅니다.
124      *
125      * @param _from The address of the sender(보낸 사람의 주소)
126      * @param _to The address of the recipient(받는 사람의 주소)
127      * @param _value the amount to send(발송액)
128      */
129     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
130         require(_value <= allowance[_from][msg.sender]);     // Check allowance(수당)
131         allowance[_from][msg.sender] -= _value;
132         _transfer(_from, _to, _value);
133         return true;
134     }
135 
136     /**
137      * Set allowance for other address
138      *
139      * Allows `_spender` to spend no more than `_value` tokens on your behalf
140      * `_spender`에서 귀하를 대신하여 `_value` 토큰만 사용하도록 허용합니다.
141      *
142      * @param _spender The address authorized to spend(사용 허가된 주소)
143      * @param _value the max amount they can spend(그들이 지출할 수 있는 최대액)
144      */
145     function approve(address _spender, uint256 _value) public
146         returns (bool success) {
147         allowance[msg.sender][_spender] = _value;
148         emit Approval(msg.sender, _spender, _value);
149         return true;
150     }
151 
152     /**
153      * Set allowance for other address and notify
154      *
155      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
156      * `_spender`가 귀하를 대신하여 `_value` 토큰을 사용한 후 계약을 할 수 있도록 허용
157      *
158      * @param _spender The address authorized to spend(사용 허가된 주소)
159      * @param _value the max amount they can spend(그들이 지출할 수 있는 최대액)
160      * @param _extraData some extra information to send to the approved contract(승인된 계약에 보낼 추가 정보)
161      */
162     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
163         public
164         returns (bool success) {
165         tokenRecipient spender = tokenRecipient(_spender);
166         if (approve(_spender, _value)) {
167             spender.receiveApproval(msg.sender, _value, this, _extraData);
168             return true;
169         }
170     }
171 
172     /**
173      * Destroy tokens
174      *
175      * Remove `_value` tokens from the system irreversibly
176      * 시스템에서 `_value` 토큰을 복구할 수 없게 제거
177      *
178      * @param _value the amount of money to burn(태울 돈)
179      */
180     function burn(uint256 _value) public returns (bool success) {
181         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough(보낸 사람이 충분한지 확인)
182         balanceOf[msg.sender] -= _value;            // Subtract from the sender(보낸 사람에서 차감)
183         totalSupply -= _value;                      // Updates totalSupply(총긍급량 업데이트)
184         emit Burn(msg.sender, _value);
185         return true;
186     }
187 
188     /**
189      * Destroy tokens from other account
190      *
191      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
192      * `_from`대신하여 시스템에서 `_value` 토큰을 복구할 수 없게 제거
193      *
194      * @param _from the address of the sender
195      * @param _value the amount of money to burn
196      */
197     function burnFrom(address _from, uint256 _value) public returns (bool success) {
198         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough(목표 잔액이 충분한 지 확인)
199         require(_value <= allowance[_from][msg.sender]);    // Check allowance(수당 확인)
200         balanceOf[_from] -= _value;                         // Subtract from the targeted balance(목표 잔액에서 차감)
201         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance(보낸 사람 수당에서 차감)
202         totalSupply -= _value;                              // Update totalSupply(총긍급량 업데이트)
203         emit Burn(_from, _value);
204         return true;
205     }
206 }