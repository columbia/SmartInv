1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 
19     // Lista dei Notai autorizzati
20     mapping (address => bool) public notaioAccounts;
21 
22     modifier onlyNotaio {
23         // Verifico che l'esecutore sia un Notaio autorizzato
24         require(isNotaio(msg.sender));
25         _;
26     }
27 
28     /// @notice Mostra lo stato di autorizzazione del Notaio
29     /// @param target l'indirizzo da verificare se presente nella lista dei Notai autorizzati
30     function isNotaio(address target) public view returns (bool status) {
31         return notaioAccounts[target];
32     }
33 
34     /// @notice Aggiunge un nuovo Notaio autorizzato
35     /// @param target l'indirizzo da aggiungere nella lista dei Notai autorizzati
36     function setNotaio(address target) onlyOwner public {
37         notaioAccounts[target] = true;
38     }
39 
40     /// @notice Rimuove un vecchio Notaio
41     /// @param target l'indirizzo da rimuovere dalla lista dei Notai autorizzati
42     function unsetNotaio(address target) onlyOwner public {
43         notaioAccounts[target] = false;
44     }
45 }
46 
47 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
48 
49 contract TokenERC20 {
50     // Informazioni sul Coin
51     string public name = "Rocati";
52     string public symbol = "Ʀ";
53     uint8 public decimals = 18;
54     uint256 public totalSupply = 50000000 * 10 ** uint256(decimals);
55 
56     // Bilanci
57     mapping (address => uint256) public balanceOf;
58     mapping (address => mapping (address => uint256)) public allowance;
59 
60     // Notifiche
61     event Transfer(address indexed from, address indexed to, uint256 value);
62     event Burn(address indexed from, uint256 value);
63 
64     /**
65      * Inizializzazione
66      */
67     function TokenERC20() public {
68         balanceOf[msg.sender] = totalSupply;
69     }
70 
71     /**
72      * Funzione interna di transfer, in uso solo allo Smart Contract
73      */
74     function _transfer(address _from, address _to, uint _value) internal {
75         // Controlli di sicurezza
76         require(_to != 0x0);
77         require(balanceOf[_from] >= _value);
78         require(balanceOf[_to] + _value > balanceOf[_to]);
79         // Salva lo stato corrente per verificarlo dopo il trasferimento
80         uint previousBalances = balanceOf[_from] + balanceOf[_to];
81         // Trasferimento del Coin con notifica
82         balanceOf[_from] -= _value;
83         balanceOf[_to] += _value;
84         Transfer(_from, _to, _value);
85         // Verifica che lo stato corrente sia coerente con quello precedente al trasferimento
86         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
87     }
88 
89     /**
90      * Transfer tokens
91      *
92      * Invia `_value` Coin dal proprio account all'indirizzo `_to`
93      *
94      * @param _to The address of the recipient
95      * @param _value the amount to send
96      */
97     function transfer(address _to, uint256 _value) public {
98         _transfer(msg.sender, _to, _value);
99     }
100 
101     /**
102      * Transfer tokens from other address
103      *
104      * Invia `_value` Coin dall'account `_from` all'indirizzo `_to`
105      *
106      * @param _from The address of the sender
107      * @param _to The address of the recipient
108      * @param _value the amount to send
109      */
110     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
111         // Controlli di sicurezza
112         require(_value <= allowance[_from][msg.sender]);
113         // Trasferimento del Coin con notifica
114         allowance[_from][msg.sender] -= _value;
115         _transfer(_from, _to, _value);
116         return true;
117     }
118 
119     /**
120      * Set allowance for other address
121      *
122      * Autorizza `_spender` a usare `_value` tuoi Coin
123      *
124      * @param _spender The address authorized to spend
125      * @param _value the max amount they can spend
126      */
127     function approve(address _spender, uint256 _value) public returns (bool success) {
128         allowance[msg.sender][_spender] = _value;
129         return true;
130     }
131 
132     /**
133      * Destroy tokens
134      *
135      * Elimina `_value` tuoi Coin
136      *
137      * @param _value the amount of money to burn
138      */
139     function burn(uint256 _value) public returns (bool success) {
140         // Controlli di sicurezza
141         require(balanceOf[msg.sender] >= _value);
142         // Eliminazione del Coin con notifica
143         balanceOf[msg.sender] -= _value;
144         totalSupply -= _value;
145         Burn(msg.sender, _value);
146         return true;
147     }
148 }
149 
150 /*****************************************/
151 /*        SMART CONTRACT DEL COIN        */
152 /*****************************************/
153 
154 contract Rocati is owned, TokenERC20 {
155     /* Inizializzazione */
156     function Rocati() TokenERC20() public {}
157 
158     /// @notice Genera `newAmount` nuovi Coin da inviare a `target` che deve essere un Notaio
159     /// @param newAmount la quantità di nuovi Coin da generare
160     /// @param target l'indirizzo che a cui inviare i nuovi Coin
161     function transferNewCoin(address target, uint256 newAmount) onlyOwner public {
162         // Controlli di sicurezza
163         require(isNotaio(target));
164         require(balanceOf[target] + newAmount > balanceOf[target]);
165         // Generazione e trasferimento del nuovo Coin con notifiche
166         balanceOf[target] += newAmount;
167         totalSupply += newAmount;
168         Transfer(0, this, newAmount);
169         Transfer(this, target, newAmount);
170     }
171 }