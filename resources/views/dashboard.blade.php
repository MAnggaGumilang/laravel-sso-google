<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
</head>
<body>
    <h2>Selamat Datang, {{ Auth::user()->name }}</h2>
    <p>Email: {{ Auth::user()->email }}</p>
    <img src="{{ Auth::user()->avatar }}" width="100" alt="Avatar">
    <br><br>
    <a href="{{ route('logout') }}">Logout</a>
</body>
</html>
