1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 /*
66  * Базовый контракт, который поддерживает остановку продаж
67  */
68 
69 contract Haltable is Ownable {
70     bool public halted;
71 
72     modifier stopInEmergency {
73         require(!halted);
74         _;
75     }
76 
77     /* Модификатор, который вызывается в потомках */
78     modifier onlyInEmergency {
79         require(halted);
80         _;
81     }
82 
83     /* Вызов функции прервет продажи, вызывать может только владелец */
84     function halt() external onlyOwner {
85         halted = true;
86     }
87 
88     /* Вызов возвращает режим продаж */
89     function unhalt() external onlyOwner onlyInEmergency {
90         halted = false;
91     }
92 
93 }
94 
95 /**
96  * Контракт лута
97  */
98 
99 contract ImpLoot is Haltable {
100 
101     struct TemplateState {
102         uint weiAmount;
103         mapping (address => address) owners;
104     }
105 
106     address private destinationWallet;
107 
108     // Мапа id шаблона лута => стейт лута
109     mapping (uint => TemplateState) private templatesState;
110 
111     // Событие покупки
112     event Bought(address _receiver, uint _lootTemplateId, uint _weiAmount);
113 
114     constructor(address _destinationWallet) public {
115         require(_destinationWallet != address(0));
116         destinationWallet = _destinationWallet;
117     }
118 
119     function buy(uint _lootTemplateId) payable stopInEmergency{
120         uint weiAmount = msg.value;
121         address receiver = msg.sender;
122 
123         require(destinationWallet != address(0));
124         require(weiAmount != 0);
125         require(templatesState[_lootTemplateId].owners[receiver] != receiver);
126         require(templatesState[_lootTemplateId].weiAmount == weiAmount);
127 
128         templatesState[_lootTemplateId].owners[receiver] = receiver;
129 
130         destinationWallet.transfer(weiAmount);
131 
132         emit Bought(receiver, _lootTemplateId, weiAmount);
133     }
134 
135     function getPrice(uint _lootTemplateId) constant returns (uint weiAmount) {
136         return templatesState[_lootTemplateId].weiAmount;
137     }
138 
139     function setPrice(uint _lootTemplateId, uint _weiAmount) external onlyOwner {
140         templatesState[_lootTemplateId].weiAmount = _weiAmount;
141     }
142 
143     function isOwner(uint _lootTemplateId, address _owner) constant returns (bool isOwner){
144         return templatesState[_lootTemplateId].owners[_owner] == _owner;
145     }
146 
147     function setDestinationWallet(address _walletAddress) external onlyOwner {
148         require(_walletAddress != address(0));
149 
150         destinationWallet = _walletAddress;
151     }
152 
153     function getDestinationWallet() constant returns (address wallet) {
154         return destinationWallet;
155     }
156 }