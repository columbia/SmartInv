1 pragma solidity ^0.4.25;
2 
3 /*                                                                                                                   
4              
5                                                                                                                                                             
6                   :$%`                                                                                                                                      
7                 .!|':$:                                                                                                                                     
8                '%;   `%!.                                                                                                                                   
9       .'.     ;%'      !%`     '`                                               '!'                :|||!;`                             .;|'       .;|'      
10       '$$$$!:||.        :$;:%$$$!           '$;         :$'      '`       '.    :$:               .!%' .:%$:                             :$%`    ;$|.       
11       ;%%%';$$$!`      :%$$%:!%%%`          :$;                :%'      ;|`     :$:               .!%`   :$;                               !$! '%%'         
12      .|;.;$|`  .;%$$$$|'   :$|`'%:          :$;         :$'  `!$$%|;. '|$$||:   :$:    :$%;!%%`   .!$!;!%$:     .|$|;|$;    `|$!;|$;        `|$$;           
13      '%::$$%' `|$$!`'|$$;..!$$|:!!          :$;         :$'    !|`     .|!.     :$:   :$;...'|!.  .!%:``'!$%`  .!%'...;$:  .||'...;$:       ;$$$|`          
14      ;$$|':%$%:         .!$$|';$$%`         :$;         :$'    !|`     .|!.     :$:   :$:         .!%`    '%|. .!|.        .|!.           '%%'  !$;         
15     .!$$$|` '%:         .|!. :%$$$:         :$!`....    :$'    ;$: ''  .!%' `.  :$:    !$!` .;;.  .!%' .`;%$:   '%%:. `!'   '$%:. '!'   .!$;     `%$:       
16     .!$!.    '%;       `|!.    '%$:         `!!!!!!`    '!`     `;!:.    `;!'   `!`      '!!;`     :!!!!!:.       .;!!:.      `;!;'    `!;.        '!:      
17        '%%:   '%;     `|!   .!$!.                                                                                                                           
18           ;$|. `%;   `%;  '%%'                                                                                                                              
19             `%$:'|! '%;`|$!                 `;....''... `''':``. .`;`  .'`.`:'`''''''```.'..'``. .':``'..  ::`. .''.  ''`.  ':`.`'..:` `'......` .`'`..     
20                ;$$$$$$$%`                   .'.`'``..'. .. ''```'`.'.  .'`.`''`. .`. .``'..' ..  .''``..'  .. . .''.  `:'``.''`.`'.`'`.`'.`..``````..'`     
21                  `|$$;                                                                                                                                      
22                                                                                                                                                             
23                                                                                                                                                             
24 */                                                                                                                                                   
25 
26 contract Ownable {
27 
28     address public owner;
29 
30     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31 
32     constructor() public {
33         owner = msg.sender;
34     }
35 
36     modifier onlyOwner() {
37         require(msg.sender == owner);
38         _;
39     }
40 
41     function transferOwnership(address newOwner) public onlyOwner {
42         require(newOwner != address(0));
43         owner = newOwner;
44         emit OwnershipTransferred(owner, newOwner);
45     }
46 }
47 
48 contract ERC20 {
49 
50     function allowance(address owner, address spender) public view returns (uint256);
51 
52     function transferFrom(address from, address to, uint256 value) public returns (bool);
53 
54     function approve(address spender, uint256 value) public returns (bool);
55 
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57     
58     function balanceOf(address owner) public view returns (uint256);
59      
60     function symbol() public view returns (string);
61       
62     function decimals() public view returns (uint);  
63       
64     function totalSupply() public view returns (uint256);
65 }
66 
67 
68 contract LT_Sender_Public is Ownable {
69 
70     function multisend(address _tokenAddr, address[] dests, uint256[] values) public returns (uint256) {
71         uint256 i = 0;
72         while (i < dests.length) {
73            ERC20(_tokenAddr).transferFrom(msg.sender, dests[i], values[i]);
74            i += 1;
75         }
76         return(i);
77     }
78     
79     function searchTokenMsg ( address _tokenAddr ) public view returns (string,uint256,uint256,uint256){
80         uint size = (10 ** ERC20(_tokenAddr).decimals());
81         return( ERC20(_tokenAddr).symbol(),ERC20(_tokenAddr).totalSupply() / size,ERC20(_tokenAddr).balanceOf(msg.sender) / size,ERC20(_tokenAddr).allowance(msg.sender,this) / size);
82     }
83 }