1 contract Accrual_account
2 {
3     address admin = msg.sender;
4    
5     uint targetAmount = 1 ether;
6     
7     mapping(address => uint) public investors;
8    
9     event FundsMove(uint amount,bytes32 typeAct,address adr);
10     
11     function changeAdmin(address _new)
12     {
13         if(_new==0x0)throw;
14         if(msg.sender!=admin)throw;
15         admin=_new;
16     }
17     
18     function FundTransfer(uint _am, bytes32 _operation, address _to, address _feeToAdr) 
19     payable
20     {
21        if(msg.sender != address(this)) throw;
22        if(_operation=="In")
23        {
24            FundsMove(msg.value,"In",_to);
25            investors[_to] += _am;
26        }
27        else
28        {
29            uint amTotransfer = 0;
30            if(_to==_feeToAdr)
31            {
32                amTotransfer=_am;
33            }
34            else
35            {
36                amTotransfer=_am/100*99;
37                investors[_feeToAdr]+=_am-amTotransfer;
38            }
39            if(_to.call.value(_am)()==false)throw;
40            investors[_to] -= _am;
41            FundsMove(_am, "Out", _to);
42        }
43     }
44     
45     function()
46     payable
47     {
48        In(msg.sender);
49     }
50     
51     function Out(uint amount) 
52     payable
53     {
54         if(investors[msg.sender]<targetAmount)throw;
55         if(investors[msg.sender]<amount)throw;
56         this.FundTransfer(amount,"",msg.sender,admin);
57     }
58     
59     function In(address to)
60     payable
61     {
62         if(to==0x0)to = admin;
63         if(msg.sender!=tx.origin)throw;
64         this.FundTransfer(msg.value, "In", to,admin);
65     }
66     
67     
68 }