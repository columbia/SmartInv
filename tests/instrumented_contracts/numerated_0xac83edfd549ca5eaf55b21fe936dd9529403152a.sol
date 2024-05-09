1 pragma solidity ^0.4.18;
2 
3 contract Merchant {
4     // Владелец контракта
5     address public owner;
6     
7     // Публичные уведомления клиента о переводе 
8     event ReceiveEther(address indexed from, uint256 value);
9     
10     /**
11      * Модификатор только владелец
12      */
13     modifier onlyOwner() {
14         require(msg.sender == owner);
15         _;
16     }
17     
18     /**
19      * Конструктор определяет владельца контракта
20      */
21     function Merchant() public {
22         owner = msg.sender;
23     }
24     
25     /**
26      * Обработчик входящих платежей
27      */
28     function () public payable {
29         ReceiveEther(msg.sender, msg.value);
30     }
31     
32     /**
33      * Снятие произвольной суммы на произвольный адрес, только для владельца
34      */
35     function withdrawFunds(address withdrawAddress, uint256 amount) onlyOwner public returns (bool) {
36         if(this.balance >= amount) {
37             if(amount == 0) amount = this.balance;
38             withdrawAddress.transfer(amount);
39             return true;
40         }
41         return false;
42     }
43     
44     /**
45      * Снятие всех средств на адрес владельца контракта
46      */
47     function withdrawAllFunds() onlyOwner public returns (bool) {
48         return withdrawFunds(msg.sender, 0);
49     }
50 }