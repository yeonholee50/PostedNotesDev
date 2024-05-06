document.getElementById('registerForm').addEventListener('submit', async function(event) {
    event.preventDefault();
    const username = document.getElementById('username').value;
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;

    try {
        const response = await axios.post('/register', {
            username: username,
            email: email,
            password: password
        });
        console.log(response.data);
        alert('Registration successful!');
    } catch (error) {
        console.error(error.response.data);
        alert('Registration failed. Please try again.');
    }
});

document.getElementById('loginForm').addEventListener('submit', async function(event) {
    event.preventDefault();
    const username = document.getElementById('loginUsername').value;
    const password = document.getElementById('loginPassword').value;

    try {
        const response = await axios.post('/login', {
            username: username,
            password: password
        });
        console.log(response.data);
        alert('Login successful!');
    } catch (error) {
        console.error(error.response.data);
        alert('Login failed. Please check your credentials and try again.');
    }
});
