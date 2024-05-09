1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) onlyOwner public {
33     require(newOwner != address(0));
34     OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 
40 
41 /**
42  * @title Destructible
43  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
44  * @dev From https://github.com/OpenZeppelin/openzeppelin-solidity/blob/v1.8.0/contracts/lifecycle/Destructible.sol
45  */
46 contract Destructible is Ownable {
47 
48   function Destructible() public payable { }
49 
50   /**
51    * @dev Transfers the current balance to the owner and terminates the contract.
52    */
53   function destroy() onlyOwner public {
54     selfdestruct(owner);
55   }
56 
57   function destroyAndSend(address _recipient) onlyOwner public {
58     selfdestruct(_recipient);
59   }
60 }
61 
62 
63 /// @dev From https://github.com/KyberNetwork/smart-contracts/blob/master/contracts/ERC20Interface.sol
64 interface ERC20 {
65     function totalSupply() public view returns (uint supply);
66     function balanceOf(address _owner) public view returns (uint balance);
67     function transfer(address _to, uint _value) public returns (bool success);
68     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
69     function approve(address _spender, uint _value) public returns (bool success);
70     function allowance(address _owner, address _spender) public view returns (uint remaining);
71     function decimals() public view returns(uint digits);
72     event Approval(address indexed _owner, address indexed _spender, uint _value);
73 }
74 
75 /// @title Contract for a burnable ERC
76 contract BurnableErc20 is ERC20 {
77     function burn(uint value) external;
78 }
79 
80 contract KyberNetwork {
81     function trade(
82         ERC20 src,
83         uint srcAmount,
84         ERC20 dest,
85         address destAddress,
86         uint maxDestAmount,
87         uint minConversionRate,
88         address walletId
89     )
90         public
91         payable
92         returns(uint);
93 }
94 
95 
96 /// @title A contract to burn ERC20 tokens from ETH
97 /// @notice Sends the ETH on the contract to kyber for conversion to ERC20
98 ///  The converted ERC20 is then burned
99 /// @author Request Network
100 contract Burner is Destructible {
101     /// Kyber contract that will be used for the conversion
102     KyberNetwork public kyberContract;
103 
104     // Contract for the ERC20
105     BurnableErc20 public destErc20;
106 
107     /// @param _destErc20 Destination token
108     /// @param _kyberContract Kyber contract to use
109     function Burner(address _destErc20, address _kyberContract) public {
110         // Check inputs
111         require(_destErc20 != address(0));
112         require(_kyberContract != address(0));
113 
114         destErc20 = BurnableErc20(_destErc20);
115         kyberContract = KyberNetwork(_kyberContract);
116     }
117     
118     /// Fallback function to receive the ETH to burn later
119     function() public payable { }
120 
121     /// @dev Main function. Trade the ETH for ERC20 and burn them
122     /// @param _maxSrcAmount Maximum amount of ETH to convert. If set to 0, all ETH on the
123     ///  contract will be burned
124     /// @param _maxDestAmount A limit on the amount of converted ERC20 tokens. Default value is MAX_UINT
125     /// @param _minConversionRate The minimal conversion rate. Default value is 1 (market rate)
126     /// @return amount of dest ERC20 tokens burned
127     function burn(uint _maxSrcAmount, uint _maxDestAmount, uint _minConversionRate)
128         external
129         returns(uint)
130     {
131         // ETH to convert on Kyber, by default the amount of ETH on the contract
132         // If _maxSrcAmount is defined, ethToConvert = min(balance on contract, _maxSrcAmount)
133         uint ethToConvert = address(this).balance;
134         if (_maxSrcAmount != 0 && _maxSrcAmount < ethToConvert) {
135             ethToConvert = _maxSrcAmount;
136         }
137 
138         // Set maxDestAmount to MAX_UINT if not sent as parameter
139         uint maxDestAmount = _maxDestAmount != 0 ? _maxDestAmount : 2**256 - 1;
140 
141         // Set minConversionRate to 1 if not sent as parameter
142         // A value of 1 will execute the trade according to market price in the time of the transaction confirmation
143         uint minConversionRate = _minConversionRate != 0 ? _minConversionRate : 1;
144 
145         // Convert the ETH to ERC20
146         // erc20ToBurn is the amount of the ERC20 tokens converted by Kyber that will be burned
147         uint erc20ToBurn = kyberContract.trade.value(ethToConvert)(
148             // Source. From Kyber docs, this value denotes ETH
149             ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee),
150             
151             // Source amount
152             ethToConvert,
153 
154             // Destination. Downcast BurnableErc20 to ERC20
155             ERC20(destErc20),
156             
157             // destAddress: this contract
158             this,
159             
160             // maxDestAmount
161             maxDestAmount,
162             
163             // minConversionRate 
164             minConversionRate,
165             
166             // walletId
167             0
168         );
169 
170         // Burn the converted ERC20 tokens
171         destErc20.burn(erc20ToBurn);
172 
173         return erc20ToBurn;
174     }
175 
176     /**
177     * @notice Sets the KyberNetwork contract address.
178     */  
179     function setKyberNetworkContract(address _kyberNetworkAddress) 
180         external
181         onlyOwner
182     {
183         kyberContract = KyberNetwork(_kyberNetworkAddress);
184     }
185 }