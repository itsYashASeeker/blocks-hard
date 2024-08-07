// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract Supply {
    address public owner;
    uint public adminCount;
    uint public supplierCount;
    uint public productCount;

    struct AdminI {
        uint adminId;
        address adminAdd;
        string name;
        string company_name;
        bool approved;
    }

    struct SupplierI {
        uint supplierId;
        address supplierDD;
        string name;
        address adminAdd;
    }

    struct WorkerI {
        uint workerId;
        address workerDD;
        string name;
        address supplierAdd;
    }

    struct ProductInfo {
        uint productId;
        string name;
        address supplierAddress;
        string image_url;
        string description;
    }

    struct ProductIT {
        uint healthPerc;
        address workerA;
        string place;
        string time;
        uint productId;
    }

    // uint256[] suppAddress;

    // event LogAddress(address msg2);
    event success(string msg);
    mapping(address => AdminI) public adminsM;
    // mapping(address => AdminI) public adminsTempM;
    mapping(address => mapping(address => SupplierI)) public supplierM;
    mapping(address => address) public supplierToAdmin;
    mapping(address => WorkerI[]) public workerM;
    mapping(uint => ProductIT[]) public productIM;

    AdminI[] public adminSt;
    // AdminI[] public adminTempSt;
    SupplierI[] public supplierSt;
    WorkerI[] public workerSt;
    ProductInfo[] public productSt;

    // AdminI[] public adminSt;

    constructor() {
        owner = msg.sender;
        adminCount = 0;
        supplierCount = 0;
        productCount = 0;
    }

    function checkIfOwner() public view returns (string memory) {
        require(msg.sender == owner, "false");
        return "true";
    }

    function checkIfCompAdmin(address senderAddress) public view returns (string memory) {
        require(adminsM[senderAddress].adminId != 0, "false");
        return "true";
    }

    function checkIfSupplier(address senderAddress) public view returns (string memory) {
        // uint isSuppplier=0;
        // for (uint i = 0; i < supplierM[_adminAdd].length; i++) {
        //     if(senderAddress == supplierM[_adminAdd][i].supplierDD){
        //         isSuppplier=1;
        //     }
        //     require(senderAddress == supplierM[_adminAdd][i].supplierDD, "false");
        // }
        address adminAdd = supplierToAdmin[senderAddress];
        require(supplierM[adminAdd][senderAddress].supplierId != 0, "false");
        return "true";
    }

    function registerTempNewAdmin(
        string memory _name,
        string memory _company_name,
        address _new_user
    ) public {
        AdminI memory newAdmins = AdminI({
            adminId: adminCount + 1,
            adminAdd: _new_user,
            name: _name,
            company_name: _company_name,
            approved: false
        });
        adminsM[_new_user] = newAdmins;
        adminSt.push(newAdmins);
        adminCount++;
        // supplierData[_new_user]=0;
        emit success("Temp Admin registered!!");
    }

    function registerNewAdmin(
        string memory _name,
        string memory _company_name,
        address _new_user,
        uint _user_id,
        uint _index
    ) public {
        checkIfOwner();
        // require(checkIfCompAdmin(senderAddress););
        AdminI memory newAdmins = AdminI({
            adminId: _user_id,
            adminAdd: _new_user,
            name: _name,
            company_name: _company_name,
            approved: true
        });
        adminsM[_new_user] = newAdmins;
        // adminSt.push(newAdmins);
        adminSt[_index] = newAdmins;
        // adminCount++;
        // supplierData[_new_user]=0;
        emit success("Admin registered!!");
    }

    function registerNewSupplier(
        address senderAddress,
        address _adminAddress,
        string memory _name
    ) public {
        checkIfCompAdmin(_adminAddress);
        supplierToAdmin[senderAddress] = _adminAddress;

        supplierCount = supplierCount + 1;

        SupplierI memory newSupplier = SupplierI({
            supplierId: supplierCount,
            supplierDD: senderAddress,
            name: _name,
            adminAdd: _adminAddress
        });

        supplierM[_adminAddress][senderAddress] = newSupplier;
        // supplierData[_adminAdd].push(newSupplier);
        // adminSt.push(newAdmins);
        // adminCount++;
        supplierSt.push(newSupplier);
        emit success("Supply registered!!");
    }

    // function registerNewWorker(string memory _name, address _suppAdd, address _senderAddress) public {
    //     // checkIfSupplier(_adminAdd);
    //     WorkerI memory newWorker = WorkerI({
    //         workerId: workerM[_suppAdd].length,
    //         workerDD: _senderAddress,
    //         name: _name,
    //         supplierAdd: _suppAdd
    //     });

    //     workerM[_suppAdd].push(newWorker);
    //     // adminSt.push(newAdmins);
    //     // adminCount++;

    //     emit success("Worker registered!!");
    // }

    function adminExists(address _senderAddress) public view returns (bool) {
        return adminsM[_senderAddress].approved;
    }

    function addProduct(
        string memory _name,
        address _senderAddress,
        string memory _description,
        string memory _image_url
    ) public {
        // checkIfOwner();
        // checkIfCompAdmin(msg.sender);
        bool adminExistsVar = adminExists(_senderAddress = _senderAddress);
        if (adminExistsVar == false) {
            checkIfSupplier(_senderAddress);
        }
        ProductInfo memory newProduct = ProductInfo({
            productId: productSt.length + 1,
            name: _name,
            supplierAddress: _senderAddress,
            description: _description,
            image_url: _image_url
        });
        productSt.push(newProduct);
        productCount = productCount + 1;
        emit success("Supply registered!!");
    }

    function addProductTInfo(
        address _senderAddress,
        uint _healthPerc,
        string memory _place,
        string memory _time,
        uint _productId
    ) public {
        // checkIfOwner();
        // checkIfCompAdmin();
        bool adminExistsVar = adminExists(_senderAddress = _senderAddress);
        if (adminExistsVar == false) {
            checkIfSupplier(_senderAddress);
        }
        ProductIT memory newProductIT = ProductIT({
            healthPerc: _healthPerc,
            workerA: _senderAddress,
            place: _place,
            time: _time,
            productId: _productId
        });

        productIM[_productId].push(newProductIT);
        emit success("Supply registered!!");
    }

    function getAdminCount() public view returns (uint) {
        return adminCount;
    }

    function getSupplierCount() public view returns (uint) {
        return supplierCount;
    }

    function getProductCount() public view returns (uint) {
        return productCount;
    }

    function getProductHistoryCount(uint _productId) public view returns (uint) {
        return productIM[_productId].length;
    }

    function getAdminByindex(uint _index) public view returns (AdminI memory) {
        return adminSt[_index];
    }

    function getSupplierByindex(uint _index) public view returns (SupplierI memory) {
        return supplierSt[_index];
    }

    function getProductByindex(uint _index) public view returns (ProductInfo memory) {
        return productSt[_index];
    }

    function getProductHistoryByIndex(
        uint _productId,
        uint _index
    ) public view returns (ProductIT memory) {
        return productIM[_productId][_index];
    }

    function viewAllAdmins() public view returns (AdminI[] memory) {
        AdminI[] memory adminArray = new AdminI[](adminSt.length);
        for (uint i = 0; i < adminSt.length; i++) {
            adminArray[i + 1] = adminSt[i];
        }
        return adminArray;
    }

    // function viewAllAdmins() public view returns (address) {
    //         return adminSt[0].adminAdd;
    //     }

    function viewAllSuppliers() public view returns (SupplierI[] memory) {
        // uint supc=supplierCount[_adminAdd];

        SupplierI[] memory suppArray = new SupplierI[](supplierSt.length);

        for (uint i = 0; i < supplierSt.length; i++) {
            suppArray[i] = supplierSt[i];
        }

        return suppArray;
    }

    // function viewAllWorkers(address _adminAdd) public view returns (WorkerI[] memory) {
    //     return workerM[_adminAdd];
    // }

    function getAllProducts() public view returns (ProductInfo[] memory) {
        ProductInfo[] memory prodArray = new ProductInfo[](productSt.length);

        for (uint i = 0; i < productSt.length; i++) {
            prodArray[i] = productSt[i];
        }

        return prodArray;
    }

    function getProductHist(uint _productId) public view returns (ProductIT[] memory) {
        return productIM[_productId];
    }
}
