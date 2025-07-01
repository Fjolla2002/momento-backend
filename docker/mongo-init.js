db = db.getSiblingDB('momento');

db.createUser({
    user: "admin",
    pwd: "admin",
    roles: [
        {
            role: "readWrite",
            db: "momento"
        }
    ]
});
