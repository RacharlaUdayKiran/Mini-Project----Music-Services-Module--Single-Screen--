import React from "react";

const services = [
  {
    icon: "💼",
    title: "Business",
    description: "Manage your company effectively.",
  },
  {
    icon: "📊",
    title: "Analytics",
    description: "Track performance and trends.",
  },
  {
    icon: "💬",
    title: "Support",
    description: "24/7 customer assistance.",
  },
];

const ServiceCard = ({ icon, title, description }) => (
  <div className="bg-white shadow-md rounded-2xl p-6 flex flex-col items-start space-y-3 transition hover:shadow-lg">
    <div className="text-3xl">{icon}</div>
    <h3 className="text-xl font-semibold">{title}</h3>
    <p className="text-gray-500 text-sm">{description}</p>
  </div>
);

const ServicesGrid = () => (
  <div className="min-h-screen bg-gray-100 p-6 md:p-12">
    <div className="max-w-6xl mx-auto">
      <h2 className="text-2xl font-bold mb-6">Our Services</h2>
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        {services.map((service, index) => (
          <ServiceCard key={index} {...service} />
        ))}
      </div>
    </div>
  </div>
);

export default ServicesGrid;

