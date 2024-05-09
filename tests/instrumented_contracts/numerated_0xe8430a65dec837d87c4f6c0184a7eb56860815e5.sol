1 pragma solidity ^0.4.24;
2 
3 contract MUTOCoin {
4     address owner;
5 
6     // 미스트 브라우저가 토큰을 인식하게 만드는 변수들
7     string public constant name = "MUTO";
8     string public constant symbol = "MTC";
9     uint8 public constant decimals = 8;
10     
11     // 계좌가 가지고 있는 토큰의 양
12     mapping (address => uint) public balanceOf;
13 
14     event Transfer(address from, address to, uint value);
15 
16     constructor() public {
17         balanceOf[msg.sender] = 200000000000000000;
18     }
19 
20     function transfer(address _to, uint _value) public {
21         
22         address _from = msg.sender;
23         // 주소를 입력하지 않은 경우의 예외 처리
24         require(_to != address(0));
25         // 잔고가 부족한 경우의 예외 처리                            
26         require(balanceOf[_from] >= _value);               
27 
28         balanceOf[_from] -= _value;                    
29         balanceOf[_to] += _value;
30         emit Transfer(_from, _to, _value);
31     }
32     
33     function killcontract() public {
34         if (owner == msg.sender)
35             selfdestruct(owner);
36     }
37 }