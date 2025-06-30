export default function App() {
  return (
    <div className="min-h-screen bg-gray-100 flex items-center justify-center">
      <div className="bg-white p-8 rounded shadow-md text-center">
        <h1 className="text-3xl font-bold text-blue-600">Tailwind is Working!</h1>
        <p className="mt-4 text-gray-600">
          This is a simple React + Tailwind CSS example.
        </p>
        <button className="mt-6 px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 transition">
          Click me
        </button>
      </div>
    </div>
  );
}