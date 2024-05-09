1 pragma solidity 0.4.25;
2 
3 // Констракт.
4 contract MyMileage {
5 
6     // Владелец контракта.
7     address private owner;
8 
9     // Отображение хеш сумм файлов в дату.
10     mapping(bytes32 => uint) private map;
11 
12     // Модификатор доступа "только владелец".
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     // Конструктор.
19     constructor() public {
20         owner = msg.sender;
21     }
22 
23     // Добавление записи.
24     function put(bytes32 fileHash) onlyOwner public {
25 
26         // Проверка пустого значения по ключу.
27         require(free(fileHash));
28 
29         // Установка значения.
30         map[fileHash] = now;
31     }
32 
33     // Проверка наличия значения.
34     function free(bytes32 fileHash) view public returns (bool) {
35         return map[fileHash] == 0;
36     }
37 
38     // Получение значения.
39     function get(bytes32 fileHash) view public returns (uint) {
40         return map[fileHash];
41     }
42 
43     // Получение кода подтверждения
44     // в виде хеша блока.
45     function getConfirmationCode() view public returns (bytes32) {
46         return blockhash(block.number - 6);
47     }
48 }