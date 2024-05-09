1 pragma solidity  >= 0.5.0< 0.7.0;
2 
3 contract PROCASH {
4     
5     address owner;
6     address  payable donde;
7     uint[] ident;
8     mapping(uint => username)  usuarios;
9     
10     struct username{
11            uint id;
12            string name;
13            address payable dir;
14     }
15 
16     modifier valida_user(uint _id){
17 	    require(usuarios[_id].id != _id);
18 	    _;
19 	}
20 	
21   	constructor() public{
22   	    owner = msg.sender;
23     }
24   	
25   	event RegisterUserEvent(address indexed _dire, string  indexed name , uint time);
26   	event Recarga_pay(address indexed user, uint indexed amount, uint time);
27     event set_transfer(address indexed user,address indexed referrer,uint indexed amount, uint time);
28   
29     function fondos_contract(uint256 amount) public payable{
30             require(msg.value == amount);
31             emit Recarga_pay(msg.sender, amount, now);
32     }
33     
34    	function Register(uint _id, address payable dire,  string memory _name ) payable public valida_user(_id){
35 	     	ident.push(_id);
36 			usuarios[_id] = username({
37 			    id: _id,
38 				name: _name,
39 				dir: dire
40  			});
41     	    emit  RegisterUserEvent( dire , _name ,  now );
42 	}
43 	
44 	
45 	function update_register(uint _id, address payable dire,  string memory _name) public payable{
46 	      require(owner == msg.sender);
47 	      	usuarios[_id] = username({
48 			    id: _id,
49 			    name: _name,
50 				dir: dire
51  			});
52 	       
53 	}
54 	
55 	
56 	function pay_now(uint[] memory valor, uint256[] memory monto) public payable {
57 	    uint i;
58 	    uint256 pagar;
59 
60       for ( i = 0; i < valor.length ; i++)
61          {
62             donde  = usuarios[valor[i]].dir;
63             pagar  =    monto[i];
64              pagar_cuenta(donde, pagar);
65          } 
66     
67     }
68     
69     function pagar_cuenta(address payable _dire, uint256 _monto)  payable public {
70              require(owner == msg.sender);
71             _dire.transfer(_monto);
72              emit set_transfer(msg.sender, _dire, _monto, now ); 
73     }
74     
75     function total_register() public view returns(uint){
76          require(owner == msg.sender);
77          return ident.length;
78     } 
79     
80     function mi_user(uint  valor) public view returns(string memory) {
81          return usuarios[valor].name;
82     }
83  
84     function mi_wallet(uint  valor) public view returns(address payable) {
85          return usuarios[valor].dir;
86     }
87     
88 }