/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  env: {
    NEXT_PUBLIC_API_URL: process.env.NEXT_PUBLIC_API_URL || 'http://localhost:5000/api',
  },
  async redirects() {
    return [
      {
        source: '/',
        destination: '/tasks',
        permanent: false,
      },
    ]
  },
}

module.exports = nextConfig