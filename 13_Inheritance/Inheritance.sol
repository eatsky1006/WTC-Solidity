// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

// Base contract
contract Yeye {
    event Log(string msg);

    // Define 3 virtual functions
    function hip() public virtual {
        emit Log("Yeye");
    }

    function pop() public virtual {
        emit Log("Yeye");
    }

    function yeye() public virtual {
        emit Log("Yeye");
    }
}

// First level inheritance
contract Baba is Yeye {
    // Override parent functions
    function hip() public virtual override {
        emit Log("Baba");
    }

    function pop() public virtual override {
        emit Log("Baba");
    }

    function baba() public virtual {
        emit Log("Baba");
    }
}

// Second level inheritance with multiple inheritance
contract Erzi is Yeye, Baba {
    // Resolve inheritance ambiguity with explicit override
    function hip() public virtual override(Yeye, Baba) {
        emit Log("Erzi");
    }

    function pop() public virtual override(Yeye, Baba) {
        emit Log("Erzi");
    }

    // Call specific parent function
    function callParent() public {
        Yeye.pop();
    }

    // Call parent function using super (will call the most derived version in the inheritance hierarchy)
    function callParentSuper() public {
        super.pop();
    }
}

// Constructor inheritance examples
abstract contract A {
    uint public a;
    string public name;

    constructor(uint _a, string memory _name) {
        a = _a;
        name = _name;
    }
}

// Direct inheritance with fixed constructor parameters
contract B is A {
    constructor() A(1, "ContractB") {}
}

// Flexible constructor inheritance
contract C is A {
    constructor(uint _c, string memory _name) A(_c * _c, _name) {}
}

// Additional example showing proper inheritance patterns
contract GrandChild is Erzi {
    function hip() public virtual override {
        emit Log("GrandChild");
        super.hip(); // Calls Erzi.hip()
    }
    
    function pop() public virtual override {
        emit Log("GrandChild");
        super.pop(); // Calls Erzi.pop()
    }
}
